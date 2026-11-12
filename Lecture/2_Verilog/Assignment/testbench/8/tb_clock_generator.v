module tb_clock_generator;

wire new_clk;


reg clk;
reg reset_n;

initial clk = 1'b0;
always #100 clk = ~clk;  // f = 10 MHz

initial begin
  #0  reset_n = 1'b0;
  #10 reset_n = 1'b1;
end // initial

clock_generator #(10) dut (
  .clk      (clk    ),
  .reset_n  (reset_n),
  .new_clk  (new_clk)
);

initial begin
  $monitor($time, "ns 10M-clk: %b, 1k-clk: %b", clk, new_clk);
  #6000 $finish;
end


endmodule
