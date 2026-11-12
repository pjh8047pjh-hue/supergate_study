module traffic_tb;

reg clk = 0;
reg rst = 0;
reg x = 0;

wire hwy_r, hwy_y, hwy_g, fwy_r, fwy_y, fwy_g;


traffic traffic( hwy_r, hwy_y, hwy_g, fwy_r, fwy_y, fwy_g, x, rst, clk);

// Set clock.
always #5 clk = ~clk;
always #10 $display($time, " rst: %b, x: %b, state: %d, hwy_r: %b, hwy_y: %b, hwy_g: %b, fwy_r: %b, fwy_y: %b, fwy_g: %b",
                    rst, x,traffic.state, hwy_r, hwy_y, hwy_g, fwy_r, fwy_y, fwy_g);

// Test data.
initial begin


   #2 rst = 1;
    x = 0;
    #10 x = 0;
    #10 x = 1;
    #10 x = 0;
    #10 x = 1;
    #10 x = 0;
    #10 x = 1;
    #10 x = 0;
    #10 x = 1;
   
    $finish;

end

endmodule



