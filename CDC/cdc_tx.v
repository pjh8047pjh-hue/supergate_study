

module cdc_tx (
  input        rstb,
  input        clk1,
  input        ack,

  output       req ,
  output reg [7:0] data
);

reg [1:0] ack_r;
reg [3:0] state;
wire ena = (state == 4'h2);

always @(posedge clk1 or negedge rstb) begin
  if(~rstb) begin
    ack_r <= 2'b0;
  end else begin
    ack_r <= {ack_r[0], ack};
  end
end

// FSM
always @(posedge clk1 or negedge rstb)
begin
  if (~rstb) begin
    state <= 4'h0;
  end
  else begin
    case (state)
      4'h0: state <= 4'h1;
      4'h1: state <= 4'h2;
      4'h2: state <=  ack_r[1] ? 4'h3 : 4'h2;
      4'h3: state <= ~ack_r[1] ? 4'h0 : 4'h3;
      default: state <= 4'h0;
    endcase  // endcase;
  end
end //

wire inc = (state == 4'h3) && ~ack_r[1];
reg  [7:0] count;

always @(posedge clk1 or negedge rstb)
begin
  if (~rstb) count <= 8'h0;
  else if (inc) count <= count + 1;
end // always

always @(posedge clk1 or negedge rstb) begin
  if(~rstb) begin
    data <= 0;
  end else if(ena) begin
    data <= count;
  end
end

assign req = ena;

endmodule