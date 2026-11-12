`timescale 1ns/1ps
module tb_pkg_boundaries;
    reg clk = 0, rstb = 0;
    reg rdy = 0, req = 0, init = 0, ack_input = 0;
    reg [7:0] rx_data = 8'h1a;
    wire [7:0] addr;
    wire we;
    ass_i2c_slave_pkg_dec dut (.*);
    always #5 clk = ~clk;
    initial begin
        repeat (2) @(negedge clk);
        rstb = 1;
        init = 1;
        @(negedge clk); init = 0;
        ack_input = 1;
        @(negedge clk); ack_input = 0;
        $display("STOP_DURING_ADDRESS: pkg_state=%0d (IDLE=0 START=1)", dut.cstate);
        rdy = 1;
        @(negedge clk); rdy = 0;
        init = 1;
        @(negedge clk); init = 0;
        rx_data = 8'h2b;
        rdy = 1;
        #1;
        $display("NEW_ADDRESS_WHILE_WRITE: pkg_state=%0d we=%b old_addr=%h new_address_byte=%h",
                 dut.cstate, we, addr, rx_data);
        $finish;
    end
endmodule
