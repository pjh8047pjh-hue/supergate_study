module alu(operator, operand1, operand2, result);

input [2:0] operator;
input [7:0] operand1, operand2;

output reg [7:0] result;

always @(*) begin
	case(operator)
		3'b000: result = 0; //clear
		3'b001: result = operand1 + operand2; // Adder
		3'b010: result = operand1 - operand2; // Subtraction
		3'b011: result = operand1 ^ operand2; // Bitwise xor
		3'b100: result = operand1 >> 1; // Right shift of operand1
		3'b101: result = operand2 >> 1; // Right shift of operand2
		3'b110: result = operand1 << 1; // Left shift of operand1
		3'b111: result = operand2 << 1; // Left shift of operand2
	endcase
end
endmodule

/**************************************************************************/

module alu_block(control, A, B, Y);

input [8:0] control;
input [23:0] A, B;

output [23:0] Y;

alu alu1(.operator(control[2:0]),
       	 .operand1(A[7:0]),
      	 .operand2(B[7:0]),
      	 .result(Y[7:0]));

alu alu2(.operator(control[5:3]),
         .operand1(A[15:8]),
       	 .operand2(B[15:8]),
       	 .result(Y[15:8]));

alu alu3(.operator(control[8:6]),
         .operand1(A[23:16]),
	 .operand2(B[23:16]),
	 .result(Y[23:16]));

endmodule

/**************************************************************************/

module alu_tb();

reg [8:0] control;
reg [23:0] A, B;

wire [23:0] Y;

alu_block alu_block(control, A, B, Y);

initial begin
	control = 9'b000_000_000;
	A = 24'h00_00_00;
	B = 24'h00_00_00;
	
#5	control = 9'b001_010_011;
	A = 24'h10_A0_12;
	B = 24'h01_0A_21;

#5	control = 9'b100_101_110;
	A = 24'hCC_00_DD;
	B = 24'h00_BB_00;

#5	control = 9'b111_000_000;
	A = 24'h00_00_00;
	B = 24'hEE_00_00;

#5	$finish;

end
endmodule
