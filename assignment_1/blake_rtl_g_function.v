module blake_rtl_g_function (
    input wire          cnt_en,
    input wire [   3:0] sel_a, sel_b, sel_c, sel_d,
    input wire [  63:0] m0, m1, c0, c1,
    input wire [  63:0] a, b, c, d,
    input wire [1023:0] state,

    output reg [1023:0] state_next
);

wire [63:0] a_first, b_first, c_first, d_first;
wire [63:0] a_next, b_next, c_next, d_next;
wire [63:0] rotate_d0, rotate_b0;
wire [63:0] rotate_d1, rotate_b1;

// First half ----------------------------------------
assign a_first   = a + b + (m0 ^ c1);

assign rotate_d0 = d ^ a_first;
assign d_first   = {rotate_d0[31:0], rotate_d0[63:32]};

assign c_first   = c + d_first;

assign rotate_b0 = b ^ c_first;
assign b_first   = {rotate_b0[24:0], rotate_b0[63:25]};

// Second half ---------------------------------------
assign a_next    = a_first + b_first + (m1 ^ c0);

assign rotate_d1 = d_first ^ a_next;
assign d_next    = {rotate_d1[15:0], rotate_d1[63:16]};

assign c_next    = c_first + d_next;

assign rotate_b1 = b_first ^ c_next;
assign b_next    = {rotate_b1[10:0], rotate_b1[63:11]};


// State write MUX

assign state_next[1023:960] = (sel_a == 4'd0 ) ? a_next : state[1023:960];
assign state_next[ 959:896] = (sel_a == 4'd1 ) ? a_next : state[ 959:896];
assign state_next[ 895:832] = (sel_a == 4'd2 ) ? a_next : state[ 895:832];
assign state_next[ 831:768] = (sel_a == 4'd3 ) ? a_next : state[ 831:768];
 // b  
assign state_next[767:704]  = (sel_b == 4'd4 ) ? b_next : state[767:704];
assign state_next[703:640]  = (sel_b == 4'd5 ) ? b_next : state[703:640];
assign state_next[639:576]  = (sel_b == 4'd6 ) ? b_next : state[639:576];
assign state_next[575:512]  = (sel_b == 4'd7 ) ? b_next : state[575:512];
 // c  
assign state_next[511:448]  = (sel_c == 4'd8 ) ? c_next : state[511:448];
assign state_next[447:384]  = (sel_c == 4'd9 ) ? c_next : state[447:384];
assign state_next[383:320]  = (sel_c == 4'd10) ? c_next : state[383:320];
assign state_next[319:256]  = (sel_c == 4'd11) ? c_next : state[319:256];
 // d  
assign state_next[255:192]  = (sel_d == 4'd12) ? d_next : state[255:192];
assign state_next[191:128]  = (sel_d == 4'd13) ? d_next : state[191:128];
assign state_next[127: 64]  = (sel_d == 4'd14) ? d_next : state[127: 64];
assign state_next[ 63:  0]  = (sel_d == 4'd15) ? d_next : state[ 63:  0];

endmodule