module G_function (
    input  wire cnt_en,
    input  wire [ 3:0] sel_a, sel_b, sel_c, sel_d,
    input  wire [63:0] m0,
    input  wire [63:0] m1,
    input  wire [63:0] c0,
    input  wire [63:0] c1,
    input  wire [63:0] a,
    input  wire [63:0] b,
    input  wire [63:0] c,
    input  wire [63:0] d,

    output reg [1023:0] state
);

reg [63:0] a_next, b_next, c_next, d_next;
reg [63:0] rotate_d0, rotate_b0;
reg [63:0] rotate_d1, rotate_b1;

always @(*) begin
	state     = 1024'd0;

	rotate_d0 = 64'd0;
	rotate_b0 = 64'd0;
	rotate_d1 = 64'd0;
	rotate_b1 = 64'd0;

	a_next    = 64'd0;
	b_next    = 64'd0;
	c_next    = 64'd0;
	d_next    = 64'd0;

    if (cnt_en) begin
        a_next = a;
        b_next = b;
        c_next = c;
        d_next = d;

        a_next    = a_next + b_next + (m0 ^ c1);

        rotate_d0 = d_next ^ a_next;
        d_next    = {rotate_d0[31:0], rotate_d0[63:32]};

        c_next    = c_next + d_next;

        rotate_b0 = b_next ^ c_next;
        b_next    = {rotate_b0[24:0], rotate_b0[63:25]};

        a_next    = a_next + b_next + (m1 ^ c0);

        rotate_d1 = d_next ^ a_next;
        d_next    = {rotate_d1[15:0], rotate_d1[63:16]};

        c_next    = c_next + d_next;

        rotate_b1 = b_next ^ c_next;
        b_next    = {rotate_b1[10:0], rotate_b1[63:11]};

	    state[1023 - sel_a * 64 -: 64] = a_next;
	    state[1023 - sel_b * 64 -: 64] = b_next;
	    state[1023 - sel_c * 64 -: 64] = c_next;
	    state[1023 - sel_d * 64 -: 64] = d_next;
    end
    else begin
	    state     = 1024'd0;

		rotate_d0 = 64'd0;
		rotate_b0 = 64'd0;
		rotate_d1 = 64'd0;
		rotate_b1 = 64'd0;

		a_next    = 64'd0;
		b_next    = 64'd0;
		c_next    = 64'd0;
		d_next    = 64'd0;
    end
end

endmodule
