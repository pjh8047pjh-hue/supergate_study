module tb_sequence_detector;

reg clk;
reg reset_n;
reg data_in;



// Set clock.
initial clk = 1'b0;
always #5 clk = ~clk;

initial begin
  #0  reset_n = 1'b0;
  #10 reset_n = 1'b1;
end

initial begin
  data_in = 1'b0;
end //


wire data_out;

sequence_detector dut(
    .data_out(data_out),
    .data_in (data_in ),
    .reset_n (reset_n ),
    .clk     (clk)
);

always #10 $display($time, " reset_n: %b, data_in: %b, data_out: %b, state: %b",
                     reset_n, data_in, data_out, dut.state);

// Test data.
initial begin
    #2 reset_n = 1;
    data_in = 0;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0;
    $finish;
end

endmodule
