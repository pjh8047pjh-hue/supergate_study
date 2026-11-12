module blake_rtl_input (
	input  wire ena,
	input  wire [ 639:0] din,

	output reg  [ 639:0] msg_init,
	output wire [1023:0] v0
);

//================= Blake initialize ==================
localparam [63:0] IV0 = 64'h6A09E667F3BCC908;
localparam [63:0] IV1 = 64'hBB67AE8584CAA73B;
localparam [63:0] IV2 = 64'h3C6EF372FE94F82B;
localparam [63:0] IV3 = 64'hA54FF53A5F1D36F1;
localparam [63:0] IV4 = 64'h510E527FADE682D1;
localparam [63:0] IV5 = 64'h9B05688C2B3E6C1F;
localparam [63:0] IV6 = 64'h1F83D9ABFB41BD6B;
localparam [63:0] IV7 = 64'h5BE0CD19137E2179;

localparam [511:0] IV512 = {IV0, IV1, IV2, IV3, IV4, IV5, IV6, IV7};

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

assign v0 = {IV512, CB0, CB1, CB2, CB3,
            64'h452821E638D011F7, 64'hBE5466CF34E90EEC, CB6, CB7};
//------------------------------------------------

integer i;

always @(*) 
begin
    for (i = 0; i < 20; i = i + 1) begin
        msg_init[32*i +: 32] = ena ? swap_func(din[32*i +: 32]) : 32'b0;
    end
end

function [31:0] swap_func;
    input [31:0] x;
begin
    swap_func = {x[7:0], x[15:8], x[23:16], x[31:24]};
end
endfunction 


/*
assign msg[32*19 +: 32] = {din[32*19 + 8*0 +: 8], din[32*19 + 8*1 +: 8], din[32*19 + 8*2 +: 8], din[32*19 + 8*3 +: 8]};
assign msg[32*18 +: 32] = {din[32*18 + 8*0 +: 8], din[32*18 + 8*1 +: 8], din[32*18 + 8*2 +: 8], din[32*18 + 8*3 +: 8]};
assign msg[32*17 +: 32] = {din[32*17 + 8*0 +: 8], din[32*17 + 8*1 +: 8], din[32*17 + 8*2 +: 8], din[32*17 + 8*3 +: 8]};
assign msg[32*16 +: 32] = {din[32*16 + 8*0 +: 8], din[32*16 + 8*1 +: 8], din[32*16 + 8*2 +: 8], din[32*16 + 8*3 +: 8]};
assign msg[32*15 +: 32] = {din[32*15 + 8*0 +: 8], din[32*15 + 8*1 +: 8], din[32*15 + 8*2 +: 8], din[32*15 + 8*3 +: 8]};
assign msg[32*14 +: 32] = {din[32*14 + 8*0 +: 8], din[32*14 + 8*1 +: 8], din[32*14 + 8*2 +: 8], din[32*14 + 8*3 +: 8]};
assign msg[32*13 +: 32] = {din[32*13 + 8*0 +: 8], din[32*13 + 8*1 +: 8], din[32*13 + 8*2 +: 8], din[32*13 + 8*3 +: 8]};
assign msg[32*12 +: 32] = {din[32*12 + 8*0 +: 8], din[32*12 + 8*1 +: 8], din[32*12 + 8*2 +: 8], din[32*12 + 8*3 +: 8]};
assign msg[32*11 +: 32] = {din[32*11 + 8*0 +: 8], din[32*11 + 8*1 +: 8], din[32*11 + 8*2 +: 8], din[32*11 + 8*3 +: 8]};
assign msg[32*10 +: 32] = {din[32*10 + 8*0 +: 8], din[32*10 + 8*1 +: 8], din[32*10 + 8*2 +: 8], din[32*10 + 8*3 +: 8]};
assign msg[32*9  +: 32] = {din[32*9  + 8*0 +: 8], din[32*9  + 8*1 +: 8], din[32*9  + 8*2 +: 8], din[32*9  + 8*3 +: 8]};
assign msg[32*8  +: 32] = {din[32*8  + 8*0 +: 8], din[32*8  + 8*1 +: 8], din[32*8  + 8*2 +: 8], din[32*8  + 8*3 +: 8]};
assign msg[32*7  +: 32] = {din[32*7  + 8*0 +: 8], din[32*7  + 8*1 +: 8], din[32*7  + 8*2 +: 8], din[32*7  + 8*3 +: 8]};
assign msg[32*6  +: 32] = {din[32*6  + 8*0 +: 8], din[32*6  + 8*1 +: 8], din[32*6  + 8*2 +: 8], din[32*6  + 8*3 +: 8]};
assign msg[32*5  +: 32] = {din[32*5  + 8*0 +: 8], din[32*5  + 8*1 +: 8], din[32*5  + 8*2 +: 8], din[32*5  + 8*3 +: 8]};
assign msg[32*4  +: 32] = {din[32*4  + 8*0 +: 8], din[32*4  + 8*1 +: 8], din[32*4  + 8*2 +: 8], din[32*4  + 8*3 +: 8]};
assign msg[32*3  +: 32] = {din[32*3  + 8*0 +: 8], din[32*3  + 8*1 +: 8], din[32*3  + 8*2 +: 8], din[32*3  + 8*3 +: 8]};
assign msg[32*2  +: 32] = {din[32*2  + 8*0 +: 8], din[32*2  + 8*1 +: 8], din[32*2  + 8*2 +: 8], din[32*2  + 8*3 +: 8]};
assign msg[32*1  +: 32] = {din[32*1  + 8*0 +: 8], din[32*1  + 8*1 +: 8], din[32*1  + 8*2 +: 8], din[32*1  + 8*3 +: 8]};
assign msg[32*0  +: 32] = {din[32*0  + 8*0 +: 8], din[32*0  + 8*1 +: 8], din[32*0  + 8*2 +: 8], din[32*0  + 8*3 +: 8]};
*/

/*
always @(*) begin
    msg = 640'd0;
    if (ena) begin
        // 32-bit byte swap.
        for (i = 0; i < 20; i = i + 1) begin
            msg[639 - i*32 -: 32] = {din[615 - i*32 -: 8],
                                    din[623 - i*32 -: 8],
                                    din[631 - i*32 -: 8],
                                    din[639 - i*32 -: 8]};
        end
    end
end
*/

/*
generate for (i = 0; i < 20; i = i+1) begin
    assign msg[32*i +: 32] = ena? 32'b0: swap_func(din[32*i +: 32]);
end endgenerate 
*/

endmodule //: blake_input
