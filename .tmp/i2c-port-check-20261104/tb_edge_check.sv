`timescale 1ns/1ps
module tb_edge_check;
    reg clk = 0;
    reg rstb = 0;
    reg sda = 1;
    reg scl = 1;
    wire scl_fall, scl_rise, sda_fall, sda_rise, stop, start;
    wire [1:0] sda_d2, scl_d2;
    integer cr = 0, cf = 0, dr = 0, df = 0, st = 0, sp = 0;

    edge_detecter dut (.*);
    always #5 clk = ~clk;
    always @(posedge clk) if (rstb) begin
        cr = cr + scl_rise;
        cf = cf + scl_fall;
        dr = dr + sda_rise;
        df = df + sda_fall;
        st = st + start;
        sp = sp + stop;
    end

    initial begin
        repeat (3) @(negedge clk);
        rstb = 1;
        repeat (4) @(negedge clk);
        #1;
        cr = 0; cf = 0; dr = 0; df = 0; st = 0; sp = 0;
        scl = 0;
        repeat (4) @(negedge clk);
        #1 scl = 1;
        repeat (4) @(negedge clk);
        #1;
        if (cr != 1 || cf != 1 || dr != 0 || df != 0 || st != 0 || sp != 0)
            $fatal(1, "SCL edge detection failed");

        sda = 0;
        repeat (4) @(negedge clk);
        #1 sda = 1;
        repeat (4) @(negedge clk);
        #1;
        if (cr != 1 || cf != 1 || dr != 1 || df != 1 || st != 1 || sp != 1)
            $fatal(1, "SDA/START/STOP detection failed");
        $display("PASS: independent SCL/SDA edges and START/STOP pulses");
        $finish;
    end
endmodule
