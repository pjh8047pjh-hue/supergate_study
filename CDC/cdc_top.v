


module cdc_top (

  input        rstb,
  input        clk1,
  input        clk2,

  output       rdy ,
  output [7:0] dout

);

wire ack;
wire req;
wire [7:0] data;

cdc_tx u_cdc_tx (

  .rstb (rstb),
  .clk1 (clk1),
  .ack  (ack),

  .req  (req ),
  .data (data)
);

cdc_rx u_cdc_rx (

  .rstb (rstb),
  .clk2 (clk2),

  .ack  (ack),
  .req  (req ),
  .data (data),

  .rdy  (rdy ),
  .dout (dout)
);



endmodule