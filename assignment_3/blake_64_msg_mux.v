module blake_64_msg_mux (
	input  wire [  6:0] counter,
	input  wire [639:0] msg,

	output  reg [ 63:0] m0,
	output  reg [ 63:0] m1,
	output  reg [ 63:0] c0,
	output  reg [ 63:0] c1
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
// ================== SIGMA ========================
localparam [1023:0] const_sigma = {
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
wire [  63:0] M [0:15];
wire [ 383:0] padding;
wire [1023:0] buffer;

assign padding = {8'h80, 240'b0, 8'h01, 128'd640};
assign buffer  = {msg, padding};

assign M[0]  = buffer[1023:960];
assign M[1]  = buffer[ 959:896];
assign M[2]  = buffer[ 895:832];
assign M[3]  = buffer[ 831:768];
assign M[4]  = buffer[ 767:704];
assign M[5]  = buffer[ 703:640];
assign M[6]  = buffer[ 639:576];
assign M[7]  = buffer[ 575:512];
assign M[8]  = buffer[ 511:448];
assign M[9]  = buffer[ 447:384];
assign M[10] = buffer[ 383:320];
assign M[11] = buffer[ 319:256];
assign M[12] = buffer[ 255:192];
assign M[13] = buffer[ 191:128];
assign M[14] = buffer[  127:64];
assign M[15] = buffer[    63:0];

//------------------------------------------

//------------- select M -------------------
wire [ 2:0] cnt_g;
wire [ 3:0] cnt_round;
reg  [ 3:0] sigma0, sigma1;
reg  [63:0] round_sigma;

assign cnt_g     = counter[2:0];
assign cnt_round = counter[6:3];

//-------------- SIGMA select ---------------------
//--------------------- round mux ------------------
always @(*) begin
    case (cnt_round)
        4'h0: round_sigma = const_sigma[  63:  0];
        4'h1: round_sigma = const_sigma[ 127: 64];
        4'h2: round_sigma = const_sigma[ 191:128];
        4'h3: round_sigma = const_sigma[ 255:192];
        4'h4: round_sigma = const_sigma[ 319:256];
        4'h5: round_sigma = const_sigma[ 383:320];
        4'h6: round_sigma = const_sigma[ 447:384];
        4'h7: round_sigma = const_sigma[ 511:448];
        4'h8: round_sigma = const_sigma[ 575:512];
        4'h9: round_sigma = const_sigma[ 639:576];
        4'hA: round_sigma = const_sigma[ 703:640];
        4'hB: round_sigma = const_sigma[ 767:704];
        4'hC: round_sigma = const_sigma[ 831:768];
        4'hD: round_sigma = const_sigma[ 895:832];
        4'hE: round_sigma = const_sigma[ 959:896];
        4'hF: round_sigma = const_sigma[1023:960];
    endcase
end

//-------------------- G mux ----------------------
always @(*) begin
    case (cnt_g)
        3'd0:    {sigma1, sigma0} = round_sigma[ 7: 0];
        3'd1:    {sigma1, sigma0} = round_sigma[15: 8];
        3'd2:    {sigma1, sigma0} = round_sigma[23:16];
        3'd3:    {sigma1, sigma0} = round_sigma[31:24];
        3'd4:    {sigma1, sigma0} = round_sigma[39:32];
        3'd5:    {sigma1, sigma0} = round_sigma[47:40];
        3'd6:    {sigma1, sigma0} = round_sigma[55:48];
        3'd7:    {sigma1, sigma0} = round_sigma[63:56];
        default: {sigma1, sigma0} = 8'd0;   
    endcase
end

//------------------ c0,c1 select -----------------
always @(*) begin
    case (sigma0)
        4'h0:    c0 = CB0;
        4'h1:    c0 = CB1;
        4'h2:    c0 = CB2;
        4'h3:    c0 = CB3;
        4'h4:    c0 = CB4;
        4'h5:    c0 = CB5;
        4'h6:    c0 = CB6;
        4'h7:    c0 = CB7;
        4'h8:    c0 = CB8;
        4'h9:    c0 = CB9;
        4'hA:    c0 = CBA;
        4'hB:    c0 = CBB;
        4'hC:    c0 = CBC;
        4'hD:    c0 = CBD;
        4'hE:    c0 = CBE;
        4'hF:    c0 = CBF;
    endcase
end

always @(*) begin
    case (sigma1)
        4'h0:    c1 = CB0;
        4'h1:    c1 = CB1;
        4'h2:    c1 = CB2;
        4'h3:    c1 = CB3;
        4'h4:    c1 = CB4;
        4'h5:    c1 = CB5;
        4'h6:    c1 = CB6;
        4'h7:    c1 = CB7;
        4'h8:    c1 = CB8;
        4'h9:    c1 = CB9;
        4'hA:    c1 = CBA;
        4'hB:    c1 = CBB;
        4'hC:    c1 = CBC;
        4'hD:    c1 = CBD;
        4'hE:    c1 = CBE;
        4'hF:    c1 = CBF;
    endcase
end

//-------------------- m0, m1 select ----------------
always @(*) begin
    case (sigma0)
        4'h0:    m0 = M[0];
        4'h1:    m0 = M[1];
        4'h2:    m0 = M[2];
        4'h3:    m0 = M[3];
        4'h4:    m0 = M[4];
        4'h5:    m0 = M[5];
        4'h6:    m0 = M[6];
        4'h7:    m0 = M[7];
        4'h8:    m0 = M[8];
        4'h9:    m0 = M[9];
        4'hA:    m0 = M[10];
        4'hB:    m0 = M[11];
        4'hC:    m0 = M[12];
        4'hD:    m0 = M[13];
        4'hE:    m0 = M[14];
        4'hF:    m0 = M[15];
    endcase
end

always @(*) begin
    case (sigma1)
        4'h0:    m1 = M[0];
        4'h1:    m1 = M[1];
        4'h2:    m1 = M[2];
        4'h3:    m1 = M[3];
        4'h4:    m1 = M[4];
        4'h5:    m1 = M[5];
        4'h6:    m1 = M[6];
        4'h7:    m1 = M[7];
        4'h8:    m1 = M[8];
        4'h9:    m1 = M[9];
        4'hA:    m1 = M[10];
        4'hB:    m1 = M[11];
        4'hC:    m1 = M[12];
        4'hD:    m1 = M[13];
        4'hE:    m1 = M[14];
        4'hF:    m1 = M[15];
    endcase
end

endmodule //: msg_mux
