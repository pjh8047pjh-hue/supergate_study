`timescale 1ns/10ps

module tb_cdc_top;

reg rstb;
reg clk1;
reg clk2;

reg ena;
reg [7:0] din;

wire rdy;
wire [7:0] dout;


cdc_top dut (

  .rstb (rstb),
  .clk1 (clk1),
  .clk2 (clk2),

  .rdy  (rdy ),
  .dout (dout)

);


// ---------------------------------------
// Clock Generation
// --------------------------------------

localparam CLK1_FREQ = 100;
localparam CLK2_FREQ = 33;

// Clock 1
initial clk1 = 1'b0;
always #(1000.0/(2.0*CLK1_FREQ)) clk1 = ~clk1;


// Clock 2
initial clk2 = 1'b0;
always #(1000.0/(2.0*CLK2_FREQ)) clk2 = ~clk2;


// ---------------------------------------
// Reset generation
// --------------------------------------

initial begin
  rstb = 1'b0;
  repeat(10) @(negedge clk1);
  rstb = 1'b1;
end //




endmodule