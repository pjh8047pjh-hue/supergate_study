module ALU(
	input [2:0] operator,
	input [7:0] operand1,
	input [7:0] operand2,
	output reg [7:0] result
	);
	always@(*)begin
	case (operator)
		3'b0   :result = 0;
		3'b1   :result = operand1 + operand2;
		3'b10  :result = operand1 - operand2;
		3'b11  :result = operand1 ^ operand2;
		3'b100 :result = operand1 >> 1;
		3'b101 :result = operand2 >> 1;
		3'b110 :result = operand1 << 1;
		3'b111 :result = operand2 << 1;
	endcase	
	end
	
endmodule
