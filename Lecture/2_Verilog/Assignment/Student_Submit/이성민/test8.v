module watchmaker_tb;

wire quick_clk, slow_clk;
reg clk = 0, reset_n = 1;


watchmaker #(2) quick_watch(quick_clk, clk, reset_n);
watchmaker #(20) slow_watch(slow_clk, clk, reset_n);

always #100 clk = ~clk;  // f = 10 MHz


initial begin
    $monitor($time, "ns 10M-clk: %b, 5M-clk: %b, 500k-clk: %b",
             clk, quick_clk, slow_clk);

    reset_n = 0;
    #5 reset_n = 1;

    #6000 $finish;
end

endmodule

module watchmaker (out_clk, clk, reset_n);

//input reg clk;
output reg out_clk;
input reset_n;
input clk;

reg [31:0]count;
localparam constantNumber = 5000000000;
reg Y;
reg state_reg;

always @ (posedge(clk), posedge(reset_n))
    begin
      if (reset_n == 1'b1)
            count <= 32'b0;
        else if (count == constantNumber - 1)
            count <= 32'b0;
        else
         count <= count + 1;
end


always @(count)
    begin
        if (count == 1'b0)
            Y = 0;
        else
            Y = 1;
end

always @(posedge Y or negedge reset_n)
    begin
        if (reset_n == 1'b1)
            out_clk <= 1'b0;
        else if (Y == 1)
            out_clk <= 1'b1;
        else
            out_clk <= 1'b0;
end

endmodule

