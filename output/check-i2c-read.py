from pathlib import Path
import subprocess
import uuid
import re

source = Path('C:/Work/assignment_6/i2c_rx_assignment/design')
target = Path('C:/Work/output') / ('i2c-read-check-' + uuid.uuid4().hex[:8])
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

def run(args, cwd):
    result = subprocess.run(args, cwd=cwd, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True, errors='replace', timeout=35)
    if result.returncode:
        raise RuntimeError(result.stdout)
    return result.stdout

for variant in ['read-first-bit-fixed-nack-stop']:
    folder = target / variant
    folder.mkdir()
    for relative in files:
        text = (source / relative).read_text(encoding='utf-8-sig', errors='replace')
        if variant != 'baseline':
            text = text.replace('ass_i2c_slave_rx u_rx (',
                'ass_i2c_slave_rx #(.device_address(device_address)) u_rx (')
            text = text.replace('ass_i2c_slave_rx_ctrl u_ctrl (',
                'ass_i2c_slave_rx_ctrl #(.device_address(device_address)) u_ctrl (')
        if relative == 'rtl/ass_i2c_slave_rx_ctrl.v' and variant.startswith('read-first-bit-fixed'):
            old = "READ   : sda_oe <= (cnt_scl  < 4'd7) ? ~rdata[6 - cnt_scl] : 1'b0;"
            assert old in text
            text = text.replace(old, """READ : begin
                if (cnt_scl == 4'd8)
                    sda_oe <= ~rdata[7];
                else if (cnt_scl < 4'd7)
                    sda_oe <= ~rdata[6 - cnt_scl];
                else
                    sda_oe <= 1'b0;
            end""")
        if relative == 'tb/tb_rx.v':
            # Scratch-only stimulus: the first returned byte has bit 7 = 0.
            text = text.replace("8'hf5", "8'h55")
            needle = "u_i2c_master_top.byte (8'h00, 1'b1, 1'b0, rdata);"
            assert needle in text
            if variant.endswith('nack-stop'):
                matches = list(re.finditer(re.escape(needle), text))
                for index in (3, 1):
                    match = matches[index]
                    text = text[:match.start()] + "u_i2c_master_top.stop (8'h00, 1'b1, 1'b1, rdata);" + text[match.end():]
                stop_call = "u_i2c_master_top.stop (8'h00, 1'b1, 1'b1, rdata);"
                text = text.replace(stop_call, stop_call + '\n    $display("READ_RESULT=%h", rdata);')
            text = text.replace(needle, needle + '\n    $display("READ_RESULT=%h", rdata);')
        (folder / Path(relative).name).write_text(text, encoding='utf-8')
    run([str(bin_dir / 'vlib.exe'), 'work'], folder)
    compile_log = run([str(bin_dir / 'vlog.exe'), '-work', 'work'] +
                      [Path(relative).name for relative in files], folder)
    (folder / 'compile.log').write_text(compile_log, encoding='utf-8')
    (folder / 'check.do').write_text('''onerror {quit -code 1 -force}
onbreak {resume}
vsim -voptargs=+acc work.tb_rx
onfinish stop
run 1 ms
echo DEVICE_ADDRESS=[examine -radix hex sim:/tb_rx/dut/u_rx/u_ctrl/device_address]
echo MEMORY_0A=[examine -radix hex sim:/tb_rx/dut/u_rf/mem(10)]
quit -code 0 -force
''', encoding='utf-8')
    log = run([str(bin_dir / 'vsim.exe'), '-c', '-do', 'do check.do'], folder)
    (folder / 'simulation.log').write_text(log, encoding='utf-8')
    print(variant, flush=True)
    for line in log.splitlines():
        if ('READ_RESULT=' in line or 'DEVICE_ADDRESS=' in line or 'MEMORY_0A=' in line) and '[examine' not in line:
            print(line, flush=True)
print('Logs:', target, flush=True)
