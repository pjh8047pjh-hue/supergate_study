
`timescale 1ns / 10ps

module blake_64_1_msg_mux  (
  input  [5  :0] count,
  input  [639:0] msg  ,

  output reg [63:0] m0,
  output reg [63:0] m1,
  output reg [63:0] c0,
  output reg [63:0] c1
);


wire [1023:0] sigma = {
  64'h0123456789ABCDEF, 64'hEA489FD61C02B753, 64'hB8C052FDAE367194, 64'h7931DCBE265A40F8,
  64'h905724AFE1BC683D, 64'h2C6A0B834D75FE19, 64'hC51FED4A0763928B, 64'hDB7EC13950F4862A,
  64'h6FE9B308C2D714A5, 64'hA2847615FB9E3CD0, 64'h0123456789ABCDEF, 64'hEA489FD61C02B753,
  64'hB8C052FDAE367194, 64'h7931DCBE265A40F8, 64'h905724AFE1BC683D, 64'h2C6A0B834D75FE19
};

wire [1023:0] cb = {
  64'h243F6A8885A308D3, 64'h13198A2E03707344, 64'hA4093822299F31D0, 64'h082EFA98EC4E6C89,
  64'h452821E638D01377, 64'hBE5466CF34E90C6C, 64'hC0AC29B7C97C50DD, 64'h3F84D5B5B5470917,
  64'h9216D5D98979FB1B, 64'hD1310BA698DFB5AC, 64'h2FFD72DBD01ADFB7, 64'hB8E1AFED6A267E96,
  64'hBA7C9045F12C7F99, 64'h24A19947B3916CF7, 64'h0801F2E2858EFC16, 64'h636920D871574E69
};

wire [1023:0] md = {
  msg,
  64'h8000000000000000, 64'h0000000000000000,
  64'h0000000000000000, 64'h0000000000000001,
  64'h0000000000000000, 64'h000000000000280
};

reg [63:0] sigma_vec;
always @(*)
begin
  case (count[5:3])
    3'h0: sigma_vec = sigma[64*15 +: 64];
    3'h1: sigma_vec = sigma[64*14 +: 64];
    3'h2: sigma_vec = sigma[64*13 +: 64];
    3'h3: sigma_vec = sigma[64*12 +: 64];
    3'h4: sigma_vec = sigma[64*11 +: 64];
    3'h5: sigma_vec = sigma[64*10 +: 64];
    3'h6: sigma_vec = sigma[64*9  +: 64];
    3'h7: sigma_vec = sigma[64*8  +: 64];
  endcase
end // always

reg [7:0] idx;
always @(*)
begin
  case (count[2:0])
    3'h0: idx = sigma_vec[8*7 +: 8];
    3'h1: idx = sigma_vec[8*6 +: 8];
    3'h2: idx = sigma_vec[8*5 +: 8];
    3'h3: idx = sigma_vec[8*4 +: 8];
    3'h4: idx = sigma_vec[8*3 +: 8];
    3'h5: idx = sigma_vec[8*2 +: 8];
    3'h6: idx = sigma_vec[8*1 +: 8];
    3'h7: idx = sigma_vec[8*0 +: 8];
  endcase
end // always

always @(*)
begin
  case (idx[7:4])
    4'h0: m0 = md[64*15 +: 64];
    4'h1: m0 = md[64*14 +: 64];
    4'h2: m0 = md[64*13 +: 64];
    4'h3: m0 = md[64*12 +: 64];
    4'h4: m0 = md[64*11 +: 64];
    4'h5: m0 = md[64*10 +: 64];
    4'h6: m0 = md[64*9  +: 64];
    4'h7: m0 = md[64*8  +: 64];
    4'h8: m0 = md[64*7  +: 64];
    4'h9: m0 = md[64*6  +: 64];
    4'ha: m0 = md[64*5  +: 64];
    4'hb: m0 = md[64*4  +: 64];
    4'hc: m0 = md[64*3  +: 64];
    4'hd: m0 = md[64*2  +: 64];
    4'he: m0 = md[64*1  +: 64];
    4'hf: m0 = md[64*0  +: 64];
  endcase
end // always

always @(*)
begin
  case (idx[3:0])
    4'h0: m1 = md[64*15 +: 64];
    4'h1: m1 = md[64*14 +: 64];
    4'h2: m1 = md[64*13 +: 64];
    4'h3: m1 = md[64*12 +: 64];
    4'h4: m1 = md[64*11 +: 64];
    4'h5: m1 = md[64*10 +: 64];
    4'h6: m1 = md[64*9  +: 64];
    4'h7: m1 = md[64*8  +: 64];
    4'h8: m1 = md[64*7  +: 64];
    4'h9: m1 = md[64*6  +: 64];
    4'ha: m1 = md[64*5  +: 64];
    4'hb: m1 = md[64*4  +: 64];
    4'hc: m1 = md[64*3  +: 64];
    4'hd: m1 = md[64*2  +: 64];
    4'he: m1 = md[64*1  +: 64];
    4'hf: m1 = md[64*0  +: 64];
  endcase
end // always


always @(*)
begin
  case (idx[7:4])
    4'h0: c0 = cb[64*15 +: 64];
    4'h1: c0 = cb[64*14 +: 64];
    4'h2: c0 = cb[64*13 +: 64];
    4'h3: c0 = cb[64*12 +: 64];
    4'h4: c0 = cb[64*11 +: 64];
    4'h5: c0 = cb[64*10 +: 64];
    4'h6: c0 = cb[64*9  +: 64];
    4'h7: c0 = cb[64*8  +: 64];
    4'h8: c0 = cb[64*7  +: 64];
    4'h9: c0 = cb[64*6  +: 64];
    4'ha: c0 = cb[64*5  +: 64];
    4'hb: c0 = cb[64*4  +: 64];
    4'hc: c0 = cb[64*3  +: 64];
    4'hd: c0 = cb[64*2  +: 64];
    4'he: c0 = cb[64*1  +: 64];
    4'hf: c0 = cb[64*0  +: 64];
  endcase
end // always

always @(*)
begin
  case (idx[3:0])
    4'h0: c1 = cb[64*15 +: 64];
    4'h1: c1 = cb[64*14 +: 64];
    4'h2: c1 = cb[64*13 +: 64];
    4'h3: c1 = cb[64*12 +: 64];
    4'h4: c1 = cb[64*11 +: 64];
    4'h5: c1 = cb[64*10 +: 64];
    4'h6: c1 = cb[64*9  +: 64];
    4'h7: c1 = cb[64*8  +: 64];
    4'h8: c1 = cb[64*7  +: 64];
    4'h9: c1 = cb[64*6  +: 64];
    4'ha: c1 = cb[64*5  +: 64];
    4'hb: c1 = cb[64*4  +: 64];
    4'hc: c1 = cb[64*3  +: 64];
    4'hd: c1 = cb[64*2  +: 64];
    4'he: c1 = cb[64*1  +: 64];
    4'hf: c1 = cb[64*0  +: 64];
  endcase
end // always



endmodule