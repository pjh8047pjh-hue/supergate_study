module state_mux (
	input 		[   6:0] counter,
	input 		[1023:0] V,
	
	output wire [63:0] a,
	output wire [63:0] b,
	output wire [63:0] c,
	output wire [63:0] d,
	output wire [ 3:0] sel_a, sel_b, sel_c, sel_d
);

wire [2:0] cnt_g;
wire [3:0] cnt_round;

assign cnt_g     = counter[2:0];
assign cnt_round = counter[6:3];

assign sel_a = {2'b00, cnt_g[1:0]}; // offset + cnt_g % 4
assign sel_b = {2'd1, (cnt_g[1:0] + (cnt_g[2] ? 2'd1 : 2'd0))}; // sel_b = 4  + ((cnt_g - 3) % 4);
assign sel_c = {2'd2, (cnt_g[1:0] + (cnt_g[2] ? 2'd2 : 2'd0))}; // sel_c = 8  + ((cnt_g - 2) % 4);
assign sel_d = {2'd3, (cnt_g[1:0] + (cnt_g[2] ? 2'd3 : 2'd0))}; // sel_d = 12  + ((cnt_g - 1) % 4);

assign a = V[1023 - sel_a * 64 -: 64];
assign b = V[1023 - sel_b * 64 -: 64];
assign c = V[1023 - sel_c * 64 -: 64];
assign d = V[1023 - sel_d * 64 -: 64];

endmodule //: state_mux
