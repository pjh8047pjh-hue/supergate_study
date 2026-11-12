
`timescale 1ns/10ps

module blake_64 (

input          clk,
input          rstb,

input          ena,
input  [639:0] din,

output         rdy,
output [511:0] dout
);

//-------------- msg, state update ---------------
wire [1023:0] v0;
wire [ 639:0] msg_g0, msg_g1, msg_init;
wire [1023:0] state_0, state_next_0;
wire [1023:0] state_1, state_next_1;

//--------------- input processing ----------------
wire init_g0; 
wire init_g1;
wire cnt_en_g0, cnt_en_g1;
wire cnt_en;
wire done_g0, done_g1;

blake_64_input u_blake_64_input(
	.ena	 (ena),
	.din	 (din),
	.msg_init(msg_init),
	.v0	 	 (v0)
);

//============== state register ==================
//------------------ state_0 ------------------------
blake_rbit_2 #( 
	.N(1024)
) u_blake_rbit_2_state_0(
  	.clk (clk),
  	.rstb(rstb),
  	.init(init_g0),
  	.iv  (v0),
  	.ena (cnt_en_g0),
  	.din (state_next_0),
  	.dout(state_0)
);
 //------------------ state_1 ------------------------
blake_rbit_2 #( 
	.N(1024)
) u_blake_rbit_2_state_1(
  	.clk (clk),
  	.rstb(rstb),
  	.init(init_g1),
  	.iv  (v0),
  	.ena (cnt_en_g1),
  	.din (state_next_1),
  	.dout(state_1)
);
//=================================================

//============== mssagge register ==================
//------------------ msg_0 ------------------------
blake_rbit_1  #(
  .N(640)
) u_blake_rbit_1_msg_0(
  .clk    (clk),
  .rstb   (rstb),
  .ena    (init_g0),
  .din    (msg_init),
  .dout	  (msg_g0)
 );
 //------------------ msg_1 ------------------------
blake_rbit_1  #(
  .N(640)
) u_blake_rbit_1_msg_1(
  .clk    (clk),
  .rstb   (rstb),
  .ena    (init_g1),
  .din    (msg_init),
  .dout	  (msg_g1)
 );
//=================================================
//--------------- FSM ----------------
blake_64_fsm u_blake_64_fsm(
	.clk	  (clk),    
	.ena	  (ena),    
	.rstb	  (rstb),   
	.done_g0  (done_g0),
	.done_g1  (done_g1),
	.init_g0  (init_g0),
	.init_g1  (init_g1),
	.cnt_en_g0(cnt_en_g0),
	.cnt_en_g1(cnt_en_g1)
);

//----------- counter -------------
wire [6:0] counter_g0;
wire [6:0] counter_g1;

blake_64_counter u_blake_64_counter(
	.clk	   (clk), 
	.rstb	   (rstb), 
	.cnt_en_g0 (cnt_en_g0),
	.cnt_en_g1 (cnt_en_g1), 
	.counter_g0(counter_g0),
	.counter_g1(counter_g1),
	.done_g0   (done_g0),
	.done_g1   (done_g1)
);

//----------- msg mux_0 -------------
wire [63:0] m0_0, m1_0, c0_0, c1_0;

blake_64_msg_mux u_blake_64_msg_mux_0(
	.counter(counter_g0), 
	.msg 	(msg_g0), 
	.m0		(m0_0), 
	.m1		(m1_0), 
	.c0		(c0_0), 
	.c1		(c1_0)
);

//----------- msg mux_1 -------------
wire [63:0] m0_1, m1_1, c0_1, c1_1;

blake_64_msg_mux u_blake_64_msg_mux_1(
	.counter(counter_g1), 
	.msg 	(msg_g1), 
	.m0		(m0_1), 
	.m1		(m1_1), 
	.c0		(c0_1), 
	.c1		(c1_1)
);		

//------------ state mux_0 -----------
wire [3:0] sel_a_0, sel_b_0, sel_c_0, sel_d_0;
wire [63:0] a_0, b_0, c_0, d_0;

blake_64_state_mux u_blake_64_state_mux_0(
	.counter(counter_g0),
	.state  (state_0),
	.a		(a_0),
	.b		(b_0),
	.c		(c_0),
	.d		(d_0),
	.sel_a  (sel_a_0),
	.sel_b  (sel_b_0),
	.sel_c  (sel_c_0),
	.sel_d  (sel_d_0)
);
//------------ state mux_1 -----------
wire [ 3:0] sel_a_1, sel_b_1, sel_c_1, sel_d_1;
wire [63:0] a_1, b_1, c_1, d_1;


blake_64_state_mux u_blake_64_state_mux_1(
	.counter(counter_g1),
	.state  (state_1),
	.a		(a_1),
	.b		(b_1),
	.c		(c_1),
	.d		(d_1),
	.sel_a  (sel_a_1),
	.sel_b  (sel_b_1),
	.sel_c  (sel_c_1),
	.sel_d  (sel_d_1)
);


//-------------- g function_0 -----------
blake_64_g_function u_blake_64_g_function_0(
	.cnt_en	   (cnt_en_g0),
	.m0	   	   (m0_0), 
	.m1	   	   (m1_0), 
	.c0	   	   (c0_0), 
	.c1	   	   (c1_0),
	.a		   (a_0),
	.b		   (b_0),
	.c		   (c_0),
	.d		   (d_0),
	.sel_a	   (sel_a_0),
	.sel_b	   (sel_b_0),
	.sel_c	   (sel_c_0),
	.sel_d	   (sel_d_0),
	.state_next(state_next_0),
	.state     (state_0)
);

//-------------- g function_1 -----------
blake_64_g_function u_blake_64_g_function_1(
	.cnt_en	   (cnt_en_g1),
	.m0	   	   (m0_1), 
	.m1	   	   (m1_1), 
	.c0	   	   (c0_1), 
	.c1	   	   (c1_1),
	.a		   (a_1),
	.b		   (b_1),
	.c		   (c_1),
	.d		   (d_1),
	.sel_a	   (sel_a_1),
	.sel_b	   (sel_b_1),
	.sel_c	   (sel_c_1),
	.sel_d	   (sel_d_1),
	.state_next(state_next_1),
	.state     (state_1)
);
//------------- output comb ----------
blake_64_output_comb u_blake_64_output_comb(
	.done_g0(done_g0),
	.done_g1(done_g1),
	.state_0(state_next_0),
	.state_1(state_next_1),
	.dout   (dout),
	.rdy    (rdy)
);
endmodule
