module blake_64_output_comb (
	input  wire			  done_g0, done_g1,
	input  wire  [1023:0] state_0, state_1,

	output reg   [ 511:0] dout,
	output reg			  rdy
);
//------------------ H initialize ---------------------
localparam [63:0] IV0 = 64'h6A09E667F3BCC908;
localparam [63:0] IV1 = 64'hBB67AE8584CAA73B;
localparam [63:0] IV2 = 64'h3C6EF372FE94F82B;
localparam [63:0] IV3 = 64'hA54FF53A5F1D36F1;
localparam [63:0] IV4 = 64'h510E527FADE682D1;
localparam [63:0] IV5 = 64'h9B05688C2B3E6C1F;
localparam [63:0] IV6 = 64'h1F83D9ABFB41BD6B;
localparam [63:0] IV7 = 64'h5BE0CD19137E2179;

localparam [511:0] IV512 = {IV0, IV1, IV2, IV3, IV4, IV5, IV6, IV7};
//----------------------------------------------------
wire [1023:0] state;

assign state = (done_g0 ? state_0 : 1024'b0) |
               (done_g1 ? state_1 : 1024'b0);

wire [511:0] dout_next = {
IV512[511:448] ^ state[1023:960] ^ state[511:448],
IV512[447:384] ^ state[ 959:896] ^ state[447:384],
IV512[383:320] ^ state[ 895:832] ^ state[383:320],
IV512[319:256] ^ state[ 831:768] ^ state[319:256],
IV512[255:192] ^ state[ 767:704] ^ state[255:192],
IV512[191:128] ^ state[ 703:640] ^ state[191:128],
IV512[127: 64] ^ state[ 639:576] ^ state[ 127:64],
IV512[ 63:  0] ^ state[ 575:512] ^ state[  63: 0]};

assign rdy  = (done_g0 || done_g1);
assign dout = rdy ? dout_next : 512'b0;

endmodule //: output_comb
