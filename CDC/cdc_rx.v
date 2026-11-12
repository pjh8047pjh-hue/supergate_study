
module cdc_rx (
  input rstb,
  input clk2,

  input req ,
  input [7:0] data,

  output reg ack ,
  output reg rdy ,
  output reg [7:0] dout
);


reg [1:0] req_d2;

always @(posedge clk2 or negedge rstb) begin
  if(~rstb) begin
    req_d2 <= 2'b0;
  end else begin
    req_d2 <= {req_d2[0], req};
  end
end


always @(posedge clk2 or negedge rstb) begin
  if(~rstb) begin
    ack <= 0;
  end else begin
    ack <= req_d2[1];
  end
end

//=============================================================================
// edge detecter
reg [1:0] rdy_d2;

always @(posedge clk2 or negedge rstb) begin
  if(~rstb) begin
    rdy_d2 <= 2'b0;
  end else begin
    rdy_d2 <= {rdy_d2[0], req_d2[1]};
  end
end

assign rdy = (~rdy_d2[0] && rdy_d2[1]);
//=============================================================================

always @(posedge clk2 or negedge rstb)
begin
  if (~rstb) dout <= 8'h0;
  else if (req_d2[1]) dout <= data;
end // always

endmodule