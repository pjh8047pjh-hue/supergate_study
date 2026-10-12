
module msg_mux (
	input  wire [  6:0] counter,
	input  wire [639:0] msg,

	output wire [ 63:0] m0,
	output wire [ 63:0] m1,
	output wire [ 63:0] c0,
	output wire [ 63:0] c1
);
//--------------- CB setting ------------------
localparam [63:0] CB0 = 64'h243F6A8885A308D3;
localparam [63:0] CB1 = 64'h13198A2E03707344;
localparam [63:0] CB2 = 64'hA4093822299F31D0;
localparam [63:0] CB3 = 64'h082EFA98EC4E6C89;
localparam [63:0] CB4 = 64'h452821E638D01377;
localparam [63:0] CB5 = 64'hBE5466CF34E90C6C;
localparam [63:0] CB6 = 64'hC0AC29B7C97C50DD;
localparam [63:0] CB7 = 64'h3F84D5B5B5470917;
localparam [63:0] CB8 = 64'h9216D5D98979FB1B;
localparam [63:0] CB9 = 64'hD1310BA698DFB5AC;
localparam [63:0] CBA = 64'h2FFD72DBD01ADFB7;
localparam [63:0] CBB = 64'hB8E1AFED6A267E96;
localparam [63:0] CBC = 64'hBA7C9045F12C7F99;
localparam [63:0] CBD = 64'h24A19947B3916CF7;
localparam [63:0] CBE = 64'h0801F2E2858EFC16;
localparam [63:0] CBF = 64'h636920D871574E69;

localparam [1023:0] CB = {CBF, CBE, CBD, CBC, CBB, CBA, CB9, CB8,
                          CB7, CB6, CB5, CB4, CB3, CB2, CB1, CB0};
// ================== SIGMA ========================
localparam [1023:0] SIGMA = {
    { 4'd9, 4'd1, 4'd14, 4'd15, 4'd5, 4'd7, 4'd13, 4'd4, 4'd3, 4'd8, 4'd11, 4'd0, 4'd10, 4'd6, 4'd12, 4'd2 }, 
    { 4'd13, 4'd3, 4'd8, 4'd6, 4'd12, 4'd11, 4'd1, 4'd14, 4'd15, 4'd10, 4'd4, 4'd2, 4'd7, 4'd5, 4'd0, 4'd9 }, 
    { 4'd8, 4'd15, 4'd0, 4'd4, 4'd10, 4'd5, 4'd6, 4'd2, 4'd14, 4'd11, 4'd12, 4'd13, 4'd1, 4'd3, 4'd9, 4'd7 }, 
    { 4'd4, 4'd9, 4'd1, 4'd7, 4'd6, 4'd3, 4'd14, 4'd10, 4'd13, 4'd15, 4'd2, 4'd5, 4'd0, 4'd12, 4'd8, 4'd11 }, 
    { 4'd3, 4'd5, 4'd7, 4'd11, 4'd2, 4'd0, 4'd12, 4'd1, 4'd6, 4'd13, 4'd15, 4'd9, 4'd8, 4'd4, 4'd10, 4'd14 }, 
    { 4'd15, 4'd14, 4'd13, 4'd12, 4'd11, 4'd10, 4'd9, 4'd8, 4'd7, 4'd6, 4'd5, 4'd4, 4'd3, 4'd2, 4'd1, 4'd0 }, 
    { 4'd0, 4'd13, 4'd12, 4'd3, 4'd14, 4'd9, 4'd11, 4'd15, 4'd5, 4'd1, 4'd6, 4'd7, 4'd4, 4'd8, 4'd2, 4'd10 }, 
    { 4'd5, 4'd10, 4'd4, 4'd1, 4'd7, 4'd13, 4'd2, 4'd12, 4'd8, 4'd0, 4'd3, 4'd11, 4'd9, 4'd14, 4'd15, 4'd6 }, 
    { 4'd10, 4'd2, 4'd6, 4'd8, 4'd4, 4'd15, 4'd0, 4'd5, 4'd9, 4'd3, 4'd1, 4'd12, 4'd14, 4'd7, 4'd11, 4'd13 }, 
    { 4'd11, 4'd8, 4'd2, 4'd9, 4'd3, 4'd6, 4'd7, 4'd0, 4'd10, 4'd4, 4'd13, 4'd14, 4'd15, 4'd1, 4'd5, 4'd12 }, 
    { 4'd9, 4'd1, 4'd14, 4'd15, 4'd5, 4'd7, 4'd13, 4'd4, 4'd3, 4'd8, 4'd11, 4'd0, 4'd10, 4'd6, 4'd12, 4'd2 }, 
    { 4'd13, 4'd3, 4'd8, 4'd6, 4'd12, 4'd11, 4'd1, 4'd14, 4'd15, 4'd10, 4'd4, 4'd2, 4'd7, 4'd5, 4'd0, 4'd9 }, 
    { 4'd8, 4'd15, 4'd0, 4'd4, 4'd10, 4'd5, 4'd6, 4'd2, 4'd14, 4'd11, 4'd12, 4'd13, 4'd1, 4'd3, 4'd9, 4'd7 }, 
    { 4'd4, 4'd9, 4'd1, 4'd7, 4'd6, 4'd3, 4'd14, 4'd10, 4'd13, 4'd15, 4'd2, 4'd5, 4'd0, 4'd12, 4'd8, 4'd11 }, 
    { 4'd3, 4'd5, 4'd7, 4'd11, 4'd2, 4'd0, 4'd12, 4'd1, 4'd6, 4'd13, 4'd15, 4'd9, 4'd8, 4'd4, 4'd10, 4'd14 }, 
    { 4'd15, 4'd14, 4'd13, 4'd12, 4'd11, 4'd10, 4'd9, 4'd8, 4'd7, 4'd6, 4'd5, 4'd4, 4'd3, 4'd2, 4'd1, 4'd0 }  
};

// -------- M setting --------------
wire [63  :0] M [15:0];
wire [1023:0] buffer;
wire [383 :0] padding;

assign padding = {8'h80, 240'b0, 8'h01, 128'd640};
assign buffer  = {msg, padding};

assign M[0]  = buffer[1023:960];
assign M[1]  = buffer[959:896];
assign M[2]  = buffer[895:832];
assign M[3]  = buffer[831:768];
assign M[4]  = buffer[767:704];
assign M[5]  = buffer[703:640];
assign M[6]  = buffer[639:576];
assign M[7]  = buffer[575:512];
assign M[8]  = buffer[511:448];
assign M[9]  = buffer[447:384];
assign M[10] = buffer[383:320];
assign M[11] = buffer[319:256];
assign M[12] = buffer[255:192];
assign M[13] = buffer[191:128];
assign M[14] = buffer[127:64];
assign M[15] = buffer[63:0];

//------------------------------------------

//------------- select M -------------------
wire [2:0] cnt_g;
wire [3:0] cnt_round;
wire [3:0] sigma0, sigma1;

assign cnt_g = counter[2:0];
assign cnt_round = counter[6:3];

//-------------- SIGMA 선택 ---------------------
assign sigma0 = SIGMA[(cnt_round * 64 + cnt_g * 8) +: 4];
assign sigma1 = SIGMA[(cnt_round * 64 + cnt_g * 8 + 4) +: 4];

//-------------- 메시지, 상수 선택 ---------------
assign m0 =  M[sigma0];
assign m1 =  M[sigma1];
assign c0 = CB[sigma0 * 64 +: 64];
assign c1 = CB[sigma1 * 64 +: 64];

endmodule //: msg_mux
