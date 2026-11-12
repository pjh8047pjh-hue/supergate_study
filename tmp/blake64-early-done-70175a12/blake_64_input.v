module blake_64_input (
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


endmodule //: blake_input
