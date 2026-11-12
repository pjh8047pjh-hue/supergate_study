
`timescale 1ns/10ps

module blake_64 (

input          clk,
input          rstb,

input          ena,
input  [639:0] din,

output         rdy,
output [511:0] dout
);


wire r;
wire [1023:0] p;
wire [ 639:0] m;

blake_64_1 u0  (
  .clk  (clk),
  .rstb (rstb),
  .ena  (ena),
  .din  (din),
  .dout (p  ),
  .mout (m  ),
  .rdy  (r  )
);

blake_64_2 u1 (
  .clk  (clk  ),
  .rstb (rstb ),
  .ena  (r    ),
  .din  (m    ),
  .pin  (p    ),

  .rdy  (rdy  ),
  .dout (dout )
);

endmodule