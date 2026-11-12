`timescale 1ns/1ps
module trace_transfer;
integer reads = 0;
reg [7:0] expected;
reg read_active = 1'b0;

always @(negedge tb_rx.clk)
    read_active = tb_rx.u_i2c_master_top.rd;

always @(posedge tb_rx.u_i2c_master_top.byte_done) begin
    if (read_active) begin
    #1;
    reads = reads + 1;
    case (reads)
        1: expected = 8'hf5;
        2: expected = 8'hfb;
        3: expected = 8'h77;
        4: expected = 8'h88;
    endcase
    $display("READ_CHECK number=%0d actual=%h expected=%h t=%0t", reads,
        tb_rx.u_i2c_master_top.rxr, expected, $time);
    if (tb_rx.u_i2c_master_top.rxr !== expected) begin
        $display("FAIL: read data mismatch");
        $finish;
    end
    if (reads == 4) begin
        $display("PASS: four reads F5 FB 77 88, including NACK and next START");
        $finish;
    end
    end
end

always @(tb_rx.dut.sda_oe) begin
    if (tb_rx.reset_n === 1'b1 &&
        tb_rx.dut.sda_oe !== 1'b0 && tb_rx.dut.sda_oe !== 1'b1) begin
        $display("FAIL: SDA output enable X at %0t", $time);
        $finish;
    end
end

initial begin
    #250000;
    $display("FAIL: timeout, reads=%0d", reads);
    $finish;
end
endmodule
