module ALU_tb();
	reg [8:0]  control;
	reg [23:0]  A;
	reg [23:0]  B;
	wire [23:0]  Y;

	ALU_top u_ALU_top (
					   .A      (A      ),
					   .B      (B      ),
					   .Y      (Y      ),
					   .control(control)
					   );

initial begin
$monitor("control: %b, A: %b, B: %b, Y: %b",
             control, A, B, Y);
	control = 9'b0; 
	A = 24'b0000_0100_0100_1110_1010_0011; 
	B = 24'b1100_1011_0111_0001_0110_1101;
	#15 control = 9'b000_001_010;
	#15 control = 9'b011_100_101;
	#15 control = 9'b110_111_000;
	end

endmodule 