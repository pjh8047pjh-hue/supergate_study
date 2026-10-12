
`timescale 1ns/10ps

module blake (

input          clk,
input          rstb,

input          ena,
input  [639:0] din,

output reg         rdy,
output reg [511:0] dout
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

// =============== Main 함수 ========================
reg [1023:0] buffer;

wire [383:0] padding;
assign padding = {8'h80, 240'b0, 8'h01, 128'd640};

reg [63:0] H [0:7];
reg [63:0] V [0:15];
reg [63:0] M [0:15];

integer i;
integer cnt_round;
integer cnt_g;

reg [3:0] sel_a, sel_b, sel_c, sel_d;
reg [3:0] sigma0, sigma1;

reg [63:0] m0, m1, c0, c1;
reg [63:0] rotate_d0, rotate_b0;
reg [63:0] rotate_d1, rotate_b1;

always @(posedge clk or negedge rstb) begin
    if (!rstb) begin
        rdy  <= 1'b0;
        dout <= 512'd0;
    end
    else begin
        rdy <= 1'b0;

        if (ena) begin
            //------------------------------ bsway32 -----------------------------------
            buffer[1023:992] = {din[615:608], din[623:616], din[631:624], din[639:632]};
            buffer[991:960]  = {din[583:576], din[591:584], din[599:592], din[607:600]};
            buffer[959:928]  = {din[551:544], din[559:552], din[567:560], din[575:568]};
            buffer[927:896]  = {din[519:512], din[527:520], din[535:528], din[543:536]};
            buffer[895:864]  = {din[487:480], din[495:488], din[503:496], din[511:504]};
            buffer[863:832]  = {din[455:448], din[463:456], din[471:464], din[479:472]};
            buffer[831:800]  = {din[423:416], din[431:424], din[439:432], din[447:440]};
            buffer[799:768]  = {din[391:384], din[399:392], din[407:400], din[415:408]};
            buffer[767:736]  = {din[359:352], din[367:360], din[375:368], din[383:376]};
            buffer[735:704]  = {din[327:320], din[335:328], din[343:336], din[351:344]};
            buffer[703:672]  = {din[295:288], din[303:296], din[311:304], din[319:312]};
            buffer[671:640]  = {din[263:256], din[271:264], din[279:272], din[287:280]};
            buffer[639:608]  = {din[231:224], din[239:232], din[247:240], din[255:248]};
            buffer[607:576]  = {din[199:192], din[207:200], din[215:208], din[223:216]};
            buffer[575:544]  = {din[167:160], din[175:168], din[183:176], din[191:184]};
            buffer[543:512]  = {din[135:128], din[143:136], din[151:144], din[159:152]};
            buffer[511:480]  = {din[103:96],  din[111:104], din[119:112], din[127:120]};
            buffer[479:448]  = {din[71:64],   din[79:72],   din[87:80],   din[95:88]};
            buffer[447:416]  = {din[39:32],   din[47:40],   din[55:48],   din[63:56]};
            buffer[415:384]  = {din[7:0],     din[15:8],    din[23:16],   din[31:24]};
            // ---------- 패딩 ------------
            buffer[383:0] = padding;

            H[0] = IV0;
            H[1] = IV1;
            H[2] = IV2;
            H[3] = IV3;
            H[4] = IV4;
            H[5] = IV5;
            H[6] = IV6;
            H[7] = IV7;

            V[0]  = H[0];
            V[1]  = H[1];
            V[2]  = H[2];
            V[3]  = H[3];
            V[4]  = H[4];
            V[5]  = H[5];
            V[6]  = H[6];
            V[7]  = H[7];
            V[8]  = CB0;
            V[9]  = CB1;
            V[10] = CB2;
            V[11] = CB3;
            V[12] = 64'h452821E638D011F7;
            V[13] = 64'hBE5466CF34E90EEC;
            V[14] = CB6;
            V[15] = CB7;

            M[0]  = buffer[1023:960];
            M[1]  = buffer[959:896];
            M[2]  = buffer[895:832];
            M[3]  = buffer[831:768];
            M[4]  = buffer[767:704];
            M[5]  = buffer[703:640];
            M[6]  = buffer[639:576];
            M[7]  = buffer[575:512];
            M[8]  = buffer[511:448];
            M[9]  = buffer[447:384];
            M[10] = buffer[383:320];
            M[11] = buffer[319:256];
            M[12] = buffer[255:192];
            M[13] = buffer[191:128];
            M[14] = buffer[127:64]; 
            M[15] = buffer[63:0];

            //----------------------- 16라운드 반복 ------------------------------
            for (cnt_round = 0; cnt_round < 16; cnt_round = cnt_round + 1) begin
                $display("round : %d", cnt_round);
                //------------------ 라운드마다 G 8회 -------------------
                for (cnt_g = 0; cnt_g < 8; cnt_g = cnt_g + 1) begin
                    // --------------- V 선택 ------------------------
                    if (cnt_g < 4) begin
                        //------------- 열 방향 인덱스 계산 -----------
                        sel_a = cnt_g;
                        sel_b = cnt_g + 4;
                        sel_c = cnt_g + 8;
                        sel_d = cnt_g + 12;
                    end
                    else begin
                        //------------- 대각선 방향 인덱스 계산 -------
                        sel_a = cnt_g - 4;
                        sel_b = 4  + ((cnt_g - 3) % 4);
                        sel_c = 8  + ((cnt_g - 2) % 4);
                        sel_d = 12 + ((cnt_g - 1) % 4);
                    end

                    //-------------- SIGMA 선택 ---------------------
                    sigma0 = SIGMA[(cnt_round * 64 + cnt_g * 8) +: 4];
                    sigma1 = SIGMA[(cnt_round * 64 + cnt_g * 8 + 4) +: 4];

                    //-------------- 메시지, 상수 선택 ---------------
                    m0 = M[sigma0];
                    m1 = M[sigma1];
                    c0 = CB[sigma0 * 64 +: 64];
                    c1 = CB[sigma1 * 64 +: 64];

                    //----------------- 열 연산 ----------------------
                    V[sel_a]  = V[sel_a] + V[sel_b] + (m0 ^ c1);

                    rotate_d0 = V[sel_d] ^ V[sel_a];
                    V[sel_d]  = {rotate_d0[31:0], rotate_d0[63:32]};

                    V[sel_c]  = V[sel_c] + V[sel_d];

                    rotate_b0 = V[sel_b] ^ V[sel_c];
                    V[sel_b]  = {rotate_b0[24:0], rotate_b0[63:25]};

                    //--------------- 대각선 연산 ---------------------
                    V[sel_a]  = V[sel_a] + V[sel_b] + (m1 ^ c0);

                    rotate_d1 = V[sel_d] ^ V[sel_a];
                    V[sel_d]  = {rotate_d1[15:0], rotate_d1[63:16]};

                    V[sel_c]  = V[sel_c] + V[sel_d];

                    rotate_b1 = V[sel_b] ^ V[sel_c];
                    V[sel_b]  = {rotate_b1[10:0], rotate_b1[63:11]};
                    
                    for(i = 0; i < 16; i = i + 1) begin
                        $display("V[%d] = %16h\n", i, V[i]);
                    end
                end
            end
            
            //------------------------ H 계산 --------------------------
            H[0] = H[0] ^ V[0] ^ V[8];
            H[1] = H[1] ^ V[1] ^ V[9];
            H[2] = H[2] ^ V[2] ^ V[10];
            H[3] = H[3] ^ V[3] ^ V[11];
            H[4] = H[4] ^ V[4] ^ V[12];
            H[5] = H[5] ^ V[5] ^ V[13];
            H[6] = H[6] ^ V[6] ^ V[14];
            H[7] = H[7] ^ V[7] ^ V[15];

            dout <= {H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]};
            rdy  <= 1'b1;
        end
    end
end

/*
always @(posedge clk) begin
    if (!rstb) begin
        cnt_round <= 0;
        cnt_g <= 0;
    end
    else if (cnt_round < 16) begin
        if(cnt_g < 4) begin
            V[sel_a] <=  V[sel_a] + V[sel_b] + (M[SIGMA[sel_sigma]] ^ c1);
            V[sel_d] <= (V[sel_d] ^ V[sel_a]) >>> 32;
            V[sel_c] <=  V[sel_c] + V[sel_d];
            V[sel_b] <= (V[sel_b] ^ V[sel_c]) >>> 25;
            cnt_g <= cnt_g + 1;
        end 
        else if(cnt_g < 8) begin
            V[sel_a] <=  V[sel_a] + V[sel_b] + (M[SIGMA[sel_sigma]] ^ c0);
            V[sel_d] <= (V[sel_d] ^ V[sel_a]) >>> 16;
            V[sel_c] <=  V[sel_c] + V[sel_d];
            V[sel_b] <= (V[sel_b] ^ V[sel_c]) >>> 11;
            cnt_g <= cnt_g + 1;
        end
        else if(cnt_g == 8) begin
            cnt_g <= 0;
            cnt_round <= cnt_round + 1'd1;
        end
    end
end
*/

endmodule