module tb_sequence_generator;

reg clk;
reg reset_n;


// Set clock.
initial clk = 1'b0;
always #5 clk = ~clk;

initial begin
  #0  reset_n = 1'b0;
  #10 reset_n = 1'b1;
end

wire data_out;

sequence_generator dut(
  .clk     (clk     ),
  .reset_n (reset_n ),
  .data_out(data_out)
);


// Test data.
initial begin
    $monitor($time, " data_out: %b, state: %b", data_out, dut.state);
    #200 $finish;
end

endmodule
