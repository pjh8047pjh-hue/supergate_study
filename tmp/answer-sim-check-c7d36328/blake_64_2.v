
`timescale 1ns / 10ps

module blake_64_2  (
  input           clk ,
  input           rstb,
  input           ena ,
  input  [ 639:0] din ,
  input  [1023:0] pin ,

  output          rdy ,
  output [ 511:0] dout
);


//--------------------------------------------
// Message Register
//--------------------------------------------
wire [639:0] msg;
blake_rbit_0 #(.N(640)) u_msg
(
  .clk  (clk       ),
  .rstb (rstb      ),
  .ena  (ena       ),
  .din  (din       ),
  .dout (msg       )
);

//--------------------------------------------
// State Register
//--------------------------------------------
wire          state_update;
wire [1023:0] state_nxt;
wire [1023:0] state;

blake_rbit_2 #(.N(1024)) u_state
(
  .clk  (clk            ),
  .rstb (rstb           ),
  .init (ena            ),
  .iv   (pin            ),
  .ena  (state_update   ),
  .din  (state_nxt      ),
  .dout (state          )
);

//--------------------------------------------
// Counter Register
//--------------------------------------------
wire count_inc;
wire [5:0] count;
wire [5:0] count_nxt;
blake_rbit_2 #(.N(6)) u_count
(
  .clk  (clk         ),
  .rstb (rstb        ),
  .init (ena         ),
  .iv   (6'b0        ),
  .ena  (count_inc   ),
  .din  (count_nxt   ),
  .dout (count       )
);
assign count_nxt = count + 1'b1;

//--------------------------------------------
// FSM
//--------------------------------------------
wire done;
reg [1:0] st;
always @(posedge clk or negedge rstb)
begin
  if (~rstb) begin
    st <= 2'b0;
  end
  else begin
    case (st)
      2'b00: st <= (ena )? 2'b01: 2'b00;
      2'b01: st <= (done)? 2'b10: 2'b01;
      2'b10: st <= (ena )? 2'b01: 2'b00;
    endcase
  end
end // always

//--------------------------------------------
// Control signal generation
//--------------------------------------------
assign done = (count == 6'h3f);
assign count_inc = (st == 2'b01);
assign state_update = (st == 2'b01);

//--------------------------------------------
// Message Mux
//--------------------------------------------
wire [63:0] c0;
wire [63:0] c1;
wire [63:0] m0;
wire [63:0] m1;
blake_64_2_msg_mux u_msg_mux (
  .count (count),
  .msg   (msg  ),
  .c0    (c0   ),
  .c1    (c1   ),
  .m0    (m0   ),
  .m1    (m1   )
);

//--------------------------------------------
// State Mux
//--------------------------------------------
wire [63:0] a;
wire [63:0] b;
wire [63:0] c;
wire [63:0] d;
blake_64_2_state_mux u_state_mux (
  .count (count),
  .state (state),
  .a     (a    ),
  .b     (b    ),
  .c     (c    ),
  .d     (d    )
);

//--------------------------------------------
// G Function
//--------------------------------------------
wire [63:0] a_out;
wire [63:0] b_out;
wire [63:0] c_out;
wire [63:0] d_out;
blake_64_g_func u_g_func (
  .c0    (c0   ),
  .c1    (c1   ),
  .m0    (m0   ),
  .m1    (m1   ),
  .a     (a    ),
  .b     (b    ),
  .c     (c    ),
  .d     (d    ),
  .a_out (a_out),
  .b_out (b_out),
  .c_out (c_out),
  .d_out (d_out)
);


//--------------------------------------------
// Next State
//--------------------------------------------
assign state_nxt[64*15 +: 64] = ((count[2:0] == 3'd0) | (count[2:0] == 3'd4))? a_out: state[64*15 +: 64]; // 0
assign state_nxt[64*14 +: 64] = ((count[2:0] == 3'd1) | (count[2:0] == 3'd5))? a_out: state[64*14 +: 64]; // 1
assign state_nxt[64*13 +: 64] = ((count[2:0] == 3'd2) | (count[2:0] == 3'd6))? a_out: state[64*13 +: 64]; // 2
assign state_nxt[64*12 +: 64] = ((count[2:0] == 3'd3) | (count[2:0] == 3'd7))? a_out: state[64*12 +: 64]; // 3

assign state_nxt[64*11 +: 64] = ((count[2:0] == 3'd0) | (count[2:0] == 3'd7))? b_out: state[64*11 +: 64]; // 4
assign state_nxt[64*10 +: 64] = ((count[2:0] == 3'd1) | (count[2:0] == 3'd4))? b_out: state[64*10 +: 64]; // 5
assign state_nxt[64*9  +: 64] = ((count[2:0] == 3'd2) | (count[2:0] == 3'd5))? b_out: state[64*9  +: 64]; // 6
assign state_nxt[64*8  +: 64] = ((count[2:0] == 3'd3) | (count[2:0] == 3'd6))? b_out: state[64*8  +: 64]; // 7

assign state_nxt[64*7  +: 64] = ((count[2:0] == 3'd0) | (count[2:0] == 3'd6))? c_out: state[64*7  +: 64]; // 8
assign state_nxt[64*6  +: 64] = ((count[2:0] == 3'd1) | (count[2:0] == 3'd7))? c_out: state[64*6  +: 64]; // 9
assign state_nxt[64*5  +: 64] = ((count[2:0] == 3'd2) | (count[2:0] == 3'd4))? c_out: state[64*5  +: 64]; // A
assign state_nxt[64*4  +: 64] = ((count[2:0] == 3'd3) | (count[2:0] == 3'd5))? c_out: state[64*4  +: 64]; // B

assign state_nxt[64*3  +: 64] = ((count[2:0] == 3'd0) | (count[2:0] == 3'd5))? d_out: state[64*3  +: 64]; // C
assign state_nxt[64*2  +: 64] = ((count[2:0] == 3'd1) | (count[2:0] == 3'd6))? d_out: state[64*2  +: 64]; // D
assign state_nxt[64*1  +: 64] = ((count[2:0] == 3'd2) | (count[2:0] == 3'd7))? d_out: state[64*1  +: 64]; // E
assign state_nxt[64*0  +: 64] = ((count[2:0] == 3'd3) | (count[2:0] == 3'd4))? d_out: state[64*0  +: 64]; // F

//--------------------------------------------
// Port Output
//--------------------------------------------
assign dout[64*(7-0) +: 64] = 64'h6A09E667F3BCC908 ^ state[64*(15-0) +: 64] ^ state[64*(15-8 ) +: 64];
assign dout[64*(7-1) +: 64] = 64'hBB67AE8584CAA73B ^ state[64*(15-1) +: 64] ^ state[64*(15-9 ) +: 64];
assign dout[64*(7-2) +: 64] = 64'h3C6EF372FE94F82B ^ state[64*(15-2) +: 64] ^ state[64*(15-10) +: 64];
assign dout[64*(7-3) +: 64] = 64'hA54FF53A5F1D36F1 ^ state[64*(15-3) +: 64] ^ state[64*(15-11) +: 64];
assign dout[64*(7-4) +: 64] = 64'h510E527FADE682D1 ^ state[64*(15-4) +: 64] ^ state[64*(15-12) +: 64];
assign dout[64*(7-5) +: 64] = 64'h9B05688C2B3E6C1F ^ state[64*(15-5) +: 64] ^ state[64*(15-13) +: 64];
assign dout[64*(7-6) +: 64] = 64'h1F83D9ABFB41BD6B ^ state[64*(15-6) +: 64] ^ state[64*(15-14) +: 64];
assign dout[64*(7-7) +: 64] = 64'h5BE0CD19137E2179 ^ state[64*(15-7) +: 64] ^ state[64*(15-15) +: 64];

assign rdy  = (st == 2'b10);


endmodule