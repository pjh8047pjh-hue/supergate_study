`timescale 1ns/1ps
module trace_x;
reg reported_x = 1'b0;

always @(posedge tb_rx.clk) begin
    if (tb_rx.reset_n === 1'b1) begin
        if (tb_rx.dut.we === 1'b1)
            $display("RF_WRITE t=%0t addr=%h data=%h rx_empty=%b", $time,
                tb_rx.dut.addr, tb_rx.dut.wdata, tb_rx.dut.rx_empty);
        if (tb_rx.dut.req === 1'b1)
            $display("REQ t=%0t serdes_state=%h cnt=%d tx_empty=%b tx_ren=%b tx_fifo_data=%h tx_reg_before=%h pkg_addr=%h rf_data=%h tx_wp=%d tx_rp=%d", $time,
                tb_rx.dut.u_serdes.u_serdes_fsm.cstate,
                tb_rx.dut.u_serdes.cnt_scl,
                tb_rx.dut.tx_empty, tb_rx.dut.tx_ren,
                tb_rx.dut.tx_rdata, tb_rx.dut.u_serdes.tx_rdata,
                tb_rx.dut.addr, tb_rx.dut.rdata,
                tb_rx.dut.u_tx_fifo.wp, tb_rx.dut.u_tx_fifo.rp);
        if (tb_rx.dut.tx_wen === 1'b1)
            $display("TX_PUSH t=%0t value=%h pkg_addr=%h", $time,
                tb_rx.dut.tx_wdata, tb_rx.dut.addr);
    end
end

always @(tb_rx.dut.sda_oe) begin
    if (tb_rx.reset_n === 1'b1 &&
        tb_rx.dut.sda_oe !== 1'b0 && tb_rx.dut.sda_oe !== 1'b1 && !reported_x) begin
        reported_x = 1'b1;
        $display("FIRST_X t=%0t serdes_state=%h cnt=%d tx_empty=%b tx_fifo_data=%h tx_reg=%h req=%b pkg_addr=%h rf_data=%h", $time,
            tb_rx.dut.u_serdes.u_serdes_fsm.cstate,
            tb_rx.dut.u_serdes.cnt_scl,
            tb_rx.dut.tx_empty, tb_rx.dut.tx_rdata,
            tb_rx.dut.u_serdes.tx_rdata, tb_rx.dut.req,
            tb_rx.dut.addr, tb_rx.dut.rdata);
        $finish;
    end
end
endmodule
