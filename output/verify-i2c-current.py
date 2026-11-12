from pathlib import Path
import re
import subprocess
import uuid

source = Path('C:/Work/assignment_6/i2c_rx_assignment/design')
target = Path('C:/Work/output') / ('i2c-current-check-' + uuid.uuid4().hex[:8])
target.mkdir()
bin_dir = Path('C:/intelFPGA/20.1/modelsim_ase/win32aloem')
files = [
    'tb/i2c_master/i2c_master_bit_ctrl.v',
    'tb/i2c_master/i2c_master_byte_ctrl.v',
    'tb/i2c_master/i2c_master_top.v',
    'rtl/ass_i2c_slave_rx_ctrl.v',
    'rtl/ass_i2c_slave_rx.v',
    'rtl/ass_i2c_slave_rf.v',
    'rtl/ass_i2c_slave.v',
    'tb/tb_rx.v',
]
for relative in files:
    content = (source / relative).read_text(encoding='utf-8-sig', errors='replace')
    if relative == 'tb/tb_rx.v':
        address_pattern = r"(?m)^(\s*u_i2c_master_top\.byte\s*\(8'h0a,\s*1'b0,\s*1'b0,\s*rxr\s*\);[^\n]*)"
        content, count = re.subn(address_pattern, lambda m: m[0] + '\n    $display("FIRST_ADDR=%h", dut.u_rx.addr);', content)
        assert count == 1, count
        write_pattern = r"(?m)^(\s*u_i2c_master_top\.byte\s*\(8'hf5,\s*1'b0,\s*1'b0,\s*rxr\s*\);[^\n]*)"
        content, count = re.subn(write_pattern, lambda m: m[0] + '\n    $display("FIRST_WRITE=%h", dut.u_rf.mem[10]);', content)
        assert count == 1, count
        pattern = r"(?m)^(\s*u_i2c_master_top\.(?:byte|stop)\s*\(8'h00, 1'b1, 1'b[01], rdata\);[^\n]*)"
        content, count = re.subn(pattern, lambda m: m[0] + '\n    $display("READ_RESULT=%h", rdata);', content)
        assert count == 4, count
    (target / Path(relative).name).write_text(content, encoding='utf-8')

def run(args, filename):
    result = subprocess.run(args, cwd=target, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True, errors='replace', timeout=35)
    (target / filename).write_text(result.stdout, encoding='utf-8')
    assert result.returncode == 0, result.stdout
    return result.stdout

run([str(bin_dir / 'vlib.exe'), 'work'], 'library.log')
compile_log = run([str(bin_dir / 'vlog.exe'), '-work', 'work'] +
                  [Path(relative).name for relative in files], 'compile.log')
(target / 'check.do').write_text('''onerror {quit -code 1 -force}
onbreak {resume}
vsim -voptargs=+acc work.tb_rx
onfinish stop
run 1 ms
foreach {address expected} {10 f5 11 fb 12 77 13 88 2 55 3 aa 5 66 6 bb} {
    set actual [examine -radix hex sim:/tb_rx/dut/u_rf/mem($address)]
    if {![string equal -nocase $actual $expected]} {
        echo MEMORY_FAIL:$address:$actual
        quit -code 1 -force
    }
}
echo MEMORY_PASS
quit -code 0 -force
''', encoding='utf-8')
log = run([str(bin_dir / 'vsim.exe'), '-c', '-do', 'do check.do'], 'simulation.log')
actual = re.findall(r'^# READ_RESULT=([0-9a-fA-FxXzZ]+)', log, re.MULTILINE)
assert [value.lower() for value in actual] == ['f5', 'fb', 'fb', '77'], actual
assert '# MEMORY_PASS' in log
assert '# first_addr=0a' in log.lower()
assert '# first_write=f5' in log.lower()
print(compile_log.splitlines()[-1])
print('PASS: read bytes = ' + ', '.join(actual))
print('PASS: all eight memory writes')
print('PASS: first address received = 0A; first payload stored in mem[0A] = F5')
print('The second read starts at the last address retained after NACK.')
print('Logs:', target)
