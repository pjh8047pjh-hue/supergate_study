from pathlib import Path
import subprocess
import uuid

source = Path('C:/Work/assignment_6/i2c_rx_assignment/design')
target = Path('C:/Work/output') / ('i2c-start-trace-' + uuid.uuid4().hex[:8])
target.mkdir()
bin_dir = Path('C:/intelFPGA/20.1/modelsim_ase/win32aloem')
files = ['tb/i2c_master/i2c_master_bit_ctrl.v', 'tb/i2c_master/i2c_master_byte_ctrl.v',
         'tb/i2c_master/i2c_master_top.v', 'rtl/ass_i2c_slave_rx_ctrl.v',
         'rtl/ass_i2c_slave_rx.v', 'rtl/ass_i2c_slave_rf.v',
         'rtl/ass_i2c_slave.v', 'tb/tb_rx.v']
monitor = '''
always @(posedge clk) begin
    if (reset_n && dut.u_rx.u_ctrl.start)
        $display("TRACE_START: state=%d cnt=%d oe=%b addr=%h rdata=%h", dut.u_rx.u_ctrl.cstate, dut.u_rx.u_ctrl.cnt_scl, dut.sda_oe, dut.addr, dut.rdata);
    if (reset_n && dut.u_rx.u_ctrl.cstate == 3'd3 && dut.u_rx.u_ctrl.scl_rise && dut.u_rx.u_ctrl.cnt_scl == 4'd8)
        $display("TRACE_READ_ACK: ack_input=%b addr=%h", dut.u_rx.u_ctrl.ack_input, dut.addr);
    if (reset_n && dut.u_rx.u_ctrl.cstate == 3'd3 && dut.u_rx.u_ctrl.scl_fall && dut.u_rx.u_ctrl.cnt_scl == 4'd8)
        $strobe("TRACE_FIRST_BIT: rdata=%h oe=%b sda=%b", dut.rdata, dut.sda_oe, sda);
end
'''
for variant in ['current', 'first-bit-fixed']:
    folder = target / variant
    folder.mkdir()
    for relative in files:
        content = (source / relative).read_text(encoding='utf-8-sig', errors='replace')
        if relative == 'tb/tb_rx.v':
            content = content.replace('endmodule', monitor + '\nendmodule')
        if relative == 'rtl/ass_i2c_slave_rx_ctrl.v' and variant == 'first-bit-fixed':
            needle = "READ   : sda_oe <= (cnt_scl  < 4'd7) ? ~rdata[6 - cnt_scl] : 1'b0;"
            assert needle in content
            content = content.replace(needle, "READ : sda_oe <= (cnt_scl == 4'd8) ? ~rdata[7] : (cnt_scl < 4'd7) ? ~rdata[6 - cnt_scl] : 1'b0;")
        (folder / Path(relative).name).write_text(content, encoding='utf-8')
    def run(args):
        result = subprocess.run(args, cwd=folder, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                text=True, errors='replace', timeout=35)
        assert result.returncode == 0, result.stdout
        return result.stdout
    run([str(bin_dir / 'vlib.exe'), 'work'])
    run([str(bin_dir / 'vlog.exe'), '-work', 'work'] + [Path(f).name for f in files])
    (folder / 'trace.do').write_text('onerror {quit -code 1 -force}\nonbreak {resume}\nvsim -voptargs=+acc work.tb_rx\nonfinish stop\nrun 1 ms\nquit -code 0 -force\n')
    log = run([str(bin_dir / 'vsim.exe'), '-c', '-do', 'do trace.do'])
    (folder / 'simulation.log').write_text(log, encoding='utf-8')
    print(variant)
    print('\n'.join(line for line in log.splitlines() if line.startswith('# TRACE_')))
print('Logs:', target)
