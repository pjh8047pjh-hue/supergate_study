module blake_input (
	input wire ena,
	input wire [639:0] din,

	output reg [639:0] msg,
	output wire [511:0] H,
	output wire [1023:0] V
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

localparam [511:0] IV512 = {
IV0, IV1, IV2, IV3, IV4, IV5, IV6, IV7};
// =================== Constant =======================
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

localparam [1023:0] CB = {
CBF, CBE, CBD, CBC, CBB, CBA, CB9, CB8,
CB7, CB6, CB5, CB4, CB3, CB2, CB1, CB0
};
//=====================================================
assign H = IV512;
assign V = {IV512, CB0, CB1, CB2, CB3,
            64'h452821E638D011F7, 64'hBE5466CF34E90EEC, CB6, CB7};

integer i;
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

endmodule //: blake_input
