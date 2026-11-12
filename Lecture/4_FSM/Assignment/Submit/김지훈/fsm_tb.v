module fsm_tb;

reg clk = 0;
reg rst = 0;
reg in = 0;

wire out;

fsm fsm(out, in, rst, clk);

// Set clock.
always #5 clk = ~clk;
always #10 $display($time, " rst: %b, in: %b, out: %b, state: %d",
                    rst, in, out, fsm.state);

// Test data.
initial begin
    #2 rst = 1;
    in = 0;
    #10 in = 0;
    #10 in = 1;
    #10 in = 0;
    #10 in = 1;
    #10 in = 1;
    #10 in = 1;
    #10 in = 1;
    #10 in = 0;
    #10 in = 1;
    #10 in = 0;
    #10 in = 1;
   

    $finish;
end

endmodule


