module ALU_top(
	input reg [8:0] control,
	input reg [23:0] A, [23:0] B,
	output [23:0] Y
	);
	ALU ALU_1 (
			   .operand1(A[7:0]),
			   .operand2(B[7:0]),
			   .operator(control[2:0]),
			   .result  (Y[7:0])
		);
	ALU ALU_2 (
			   .operand1(A[15:8]),
			   .operand2(B[15:8]),
			   .operator(control[5:3]),
			   .result  (Y[15:8])
		);
	ALU ALU_3 (
			   .operand1(A[23:16]),
			   .operand2(B[23:16]),
			   .operator(control[8:6]),
			   .result  (Y[23:16])
		);
	
endmodule

