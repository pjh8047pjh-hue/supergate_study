
`timescale 1ns / 10ps

module blake_64_g_func  (
  input  [63:0] m0,
  input  [63:0] m1,
  input  [63:0] c0,
  input  [63:0] c1,
  input  [63:0] a ,
  input  [63:0] b ,
  input  [63:0] c ,
  input  [63:0] d ,

  output [63:0] a_out,
  output [63:0] b_out,
  output [63:0] c_out,
  output [63:0] d_out
);

wire [63:0] a_1 = (a + b + (m0 ^ c1));
wire [63:0] t_1 = d ^ a_1;
wire [63:0] d_1 = {t_1[31:0], t_1[63:32]}; //ROTR64(d ^ a_1, 32);
wire [63:0] c_1 = (c + d_1);
wire [63:0] x_1 = b ^ c_1;
wire [63:0] b_1 = {x_1[24:0], x_1[63:25]}; //ROTR64(b ^ c_1, 25);

wire [63:0] a_2 = (a_1 + b_1 + (m1 ^ c0));
wire [63:0] t_2 = d_1 ^ a_2;
wire [63:0] d_2 = {t_2[15:0], t_2[63:16]}; //ROTR64(d_1 ^ a_2, 16);
wire [63:0] c_2 = (c_1 + d_2);
wire [63:0] x_2 = b_1 ^ c_2;
wire [63:0] b_2 = {x_2[10:0], x_2[63:11]}; //ROTR64(b_1 ^ c_2, 11);

assign a_out = a_2;
assign b_out = b_2;
assign c_out = c_2;
assign d_out = d_2;


endmodule