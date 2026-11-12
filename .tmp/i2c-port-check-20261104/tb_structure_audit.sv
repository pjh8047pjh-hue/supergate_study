`timescale 1ns/1ps
module tb_structure_audit;
    tb_rx tb();
    always @(posedge tb.clk) if (tb.reset_n) begin
        if (tb.dut.we)
            $display("WRITE t=%0t addr=%h data=%h pkg_state=%0d", $time,
                     tb.dut.addr, tb.dut.rx_data, tb.dut.u_pkg_dec.cstate);
        if (tb.dut.req)
            $display("REQ t=%0t addr=%h rdata=%h tx_before=%h pkg_state=%0d", $time,
                     tb.dut.addr, tb.dut.rdata, tb.dut.u_serdes.tx_data,
                     tb.dut.u_pkg_dec.cstate);
    end
    always @(negedge tb.u_i2c_master_top.rd) if (tb.reset_n)
        $display("MASTER_READ t=%0t data=%h addr=%h pkg_state=%0d", $time,
                 tb.u_i2c_master_top.rxr, tb.dut.addr, tb.dut.u_pkg_dec.cstate);
endmodule
