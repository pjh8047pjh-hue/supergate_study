module sign_magnitude_to_twos_complement_tb;

wire signed [15:0] twos_complement;
reg [15:0] sign_magnitude = 0;

sign_mag I0(.out(twos_complement[15:0]), .sign_mag(sign_magnitude[15:0]));

initial begin
    $monitor("%d - sign_magnitude: %b, 2's complement: %b",
             twos_complement, sign_magnitude, twos_complement);

    #5 sign_magnitude = 16'b1101;
    #5 sign_magnitude = 16'b0011_1111;
    #5 sign_magnitude = 16'b1000_0000_0000_0000;
    #5 sign_magnitude = 16'b1000_0000_1001_0101;
    #5 sign_magnitude = 16'b1000_0000_1111_1111;
    #5 sign_magnitude = 16'b1111_1111_1111_1111;
end

endmodule

module sign_mag (sign_mag,out);

input [15:0]sign_mag;
output reg out;
wire  [15:0]net1;
wire  [15:0]net2;

assign net1 = ~sign_mag[14:0];
assign net2 = net1 + 16'b1;

always @(*)
begin
	if(sign_mag[15] == 1'b0)
		out = sign_mag[15:0];
	if(sign_mag[15] == 1'b1)
	    out = net2;
end 
endmodule
