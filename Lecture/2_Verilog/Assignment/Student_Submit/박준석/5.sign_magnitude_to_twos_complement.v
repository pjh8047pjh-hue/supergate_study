module sign_magnitude_to_twos_complement(twos_complement, sign_magnitude);

input [15:0] sign_magnitude;
output wire [15:0] twos_complement;
//output reg [15:0] twos_complement;

assign twos_complement = (sign_magnitude[15]) ? (~sign_magnitude[14:0] + 1'b1) : (sign_magnitude);

/*
always @(*) begin
	if (sign_magnitude[15] == 1) begin
		twos_complement = ~(sign_magnitude[14:0]) + 1'b1;
	end
	else begin
		twos_complement = sign_magnitude;
	end
end
*/
endmodule
