


module example (

input [7:0] in0,
input [7:0] in1,
input [7:0] in2,
input [7:0] in3,
output [7:0] out
);

wire [7:0] a[0:3];


assign a[0] = in0;
assign a[1] = in1;
assign a[2] = in2;
assign a[3] = in3;

reg [8:0] sum1, sum2, sum3_d;

always @(*)
begin
  sum1 = a[0] + a[1];
  sum2 = sum1 + a[2];
  sum3_d = sum2 + a[3];
end // always

reg [8:0] sum3;
always @(posedge clk)
begin
  sum3 <= sum3_d;
end // always

wire [7:0] q = "000" & sum3[8:3];
wire [7:0] r = "00000" & sum3[2:0];
wire [7:0] round = (r>3)? q + 1: q;

reg [7:0] round_r;
always @(posedge clk)
begin
  round_r <= round;
end // always

assign out = round_r;


endmodule