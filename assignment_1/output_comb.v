module output_comb (
	input  done,
	input  [ 511:0] H,
	input  [1023:0] state,

	output reg rdy,
	output reg [511:0] dout
);


always @(*) begin
	rdy = 1'b0;
	dout = 512'd0;

	if (done) begin
		dout = {H[511:448] ^ state[1023:960] ^ state[511:448],
		        H[447:384] ^ state[959:896] ^ state[447:384],
		        H[383:320] ^ state[895:832] ^ state[383:320],
		        H[319:256] ^ state[831:768] ^ state[319:256],
		        H[255:192] ^ state[767:704] ^ state[255:192],
		        H[191:128] ^ state[703:640] ^ state[191:128],
		        H[127:64] ^ state[639:576] ^ state[127:64],
		        H[63:0] ^ state[575:512] ^ state[63:0]};
		rdy = 1'b1;
	end
end

endmodule //: output_comb