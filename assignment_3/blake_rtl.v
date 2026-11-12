
`timescale 1ns/10ps

module blake_rtl (

input  		        clk,
input  		        rstb,
		
input  		        ena,
input  	    [639:0] din,

output wire         rdy,
output wire [511:0] dout
);

wire init, cnt_done, cnt_en, done;

//-------------- msg, state update ---------------

wire [1023:0] v0;
wire [ 639:0] msg_init;
wire [   3:0] sel_a, sel_b, sel_c, sel_d;
wire [  63:0] a_next, b_next, c_next, d_next;
wire [ 639:0] msg;
wire [1023:0] state, state_next;

//--------- msg, state flip-flop ---------
blake_rtl_filpflop u_blake_rtl_filpflop(
	.clk(clk),   
	.cnt_en(cnt_en),
	.rstb(rstb),
	.init(init),
	.rdy(rdy),
	.v0(v0),
	.msg_init(msg_init),
	.msg(msg),
	.state_next(state_next),
	.state(state)
);

//--------------- input processing ----------------
blake_rtl_input u_blake_rtl_input(
	.ena(ena),
	.din(din),
	.msg_init(msg_init),
	.v0(v0)
);

//--------------- FSM ----------------
blake_rtl_fsm u_blake_rtl_fsm(
	.clk     (clk), 
	.rstb    (rstb), 
	.ena     (ena),
	.init    (init), 
	.cnt_done(cnt_done), 
	.cnt_en  (cnt_en), 
	.done    (done)
);

//----------- counter -------------
wire [6:0] counter;

blake_rtl_counter u_blake_rtl_counter(
	.clk(clk), 
	.rstb(rstb), 
	.cnt_en(cnt_en), 
	.cnt_done(cnt_done), 
	.counter(counter)
);

//----------- msg mux -------------
wire [63:0] m0, m1, c0, c1;
wire [63:0] a, b, c, d;

blake_rtl_msg_mux u_blake_rtl_msg_mux(
	.counter(counter), 
	.msg(msg), 
	.m0(m0), 
	.m1(m1), 
	.c0(c0), 
	.c1(c1)
);

//------------ state mux -----------
blake_rtl_state_mux u_blake_rtl_state_mux(
	.counter(counter),
	.state(state),
	.a(a),
	.b(b),
	.c(c),
	.d(d),
	.sel_a(sel_a),
	.sel_b(sel_b),
	.sel_c(sel_c),
	.sel_d(sel_d)
);

//-------------- g function -----------
blake_rtl_g_function u_blake_rtl_g_function(
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
	.state_next(state_next),
	.state(state)
);

//------------- output comb ----------
blake_rtl_output_comb u_blake_rtl_output_comb(
	.done(done),
	.state(state),
	.dout(dout),
	.rdy(rdy)
);

endmodule
