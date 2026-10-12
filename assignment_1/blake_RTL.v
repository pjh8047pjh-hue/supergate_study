
`timescale 1ns/10ps

module blake (

input  		       clk,
input  		       rstb,
		
input  		       ena,
input  	   [639:0] din,

output wire        rdy,
output wire [511:0] dout
);

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
//

wire [511:0] H;
wire [1023:0] V;
reg  [63:0] M [0:15];
reg  [ 639:0] msg;
wire [ 639:0] msg_init;

wire cnt_done, cnt_en, done;
reg  [1023:0] state;
wire [1023:0] g_state;
wire [   6:0] counter;
wire [  63:0] m0, m1, c0, c1;
wire [  63:0] a, b, c, d;
wire [   3:0] sel_a, sel_b, sel_c, sel_d;


// Message and state storage.
always @(posedge clk or negedge rstb) begin
    if (!rstb) begin
        msg <= 640'd0;
        state <= 1024'd0;
    end
    else if (ena) begin
        msg <= msg_init;
        state <= V;
    end
    else if (cnt_en) begin
        state[1023 - sel_a*64 -: 64] <= g_state[1023 - sel_a*64 -: 64];
        state[1023 - sel_b*64 -: 64] <= g_state[1023 - sel_b*64 -: 64];
        state[1023 - sel_c*64 -: 64] <= g_state[1023 - sel_c*64 -: 64];
        state[1023 - sel_d*64 -: 64] <= g_state[1023 - sel_d*64 -: 64];
    end
end

blake_input u_blake_input (
	.ena(ena),
	.din(din),
	.msg(msg_init),
	.H(H),
	.V(V)
);

blake_FSM u_blake_fsm(
	.clk     (clk), 
	.rstb    (rstb), 
	.ena     (ena), 
	.cnt_done(cnt_done), 
	.cnt_en  (cnt_en), 
	.done    (done)
);

blake_counter u_blake_counter(
	.clk(clk), 
	.rstb(rstb), 
	.cnt_en(cnt_en), 
	.cnt_done(cnt_done), 
	.counter(counter)
);

msg_mux msg_mux(
	.counter(counter), 
	.msg(msg), 
	.m0(m0), 
	.m1(m1), 
	.c0(c0), 
	.c1(c1)
);

state_mux state_mux(
	.counter(counter),
	.V(state),
	.a(a),
	.b(b),
	.c(c),
	.d(d),
	.sel_a(sel_a),
	.sel_b(sel_b),
	.sel_c(sel_c),
	.sel_d(sel_d)
);

G_function G_function_inst(
	.cnt_en(cnt_en),
	.m0(m0), 
	.m1(m1), 
	.c0(c0), 
	.c1(c1),
	.a(a),
	.b(b),
	.c(c),
	.d(d),
	.sel_a(sel_a),
	.sel_b(sel_b),
	.sel_c(sel_c),
	.sel_d(sel_d),
	.state(g_state)
);


output_comb u_output_comb (
	.done(done),
	.H(H),
	.state(state),
	.rdy(rdy),
	.dout(dout)
);


//---------- output comb ----------------


endmodule
