module seq_generator_fsm (data_out, clk, reset_n);
input reset_n, clk;
output reg data_out;
parameter A=4'b0000, B=4'b0001, C=4'b0010, D=4'b0011, E=4'b0100, F=4'b0101, G=4'b0110, H=4'b0111, I=4'b1000, J=4'b1001, K=4'b1010; 

reg [3:0] state;




always @(posedge clk or negedge reset_n) 
begin
if (!reset_n)
	state <= A;
case (state) 
		A : state<=B;

		B : state<=C;
			
		C : state<=D;
				
		D : state<=E;
			
		E : state<=E;
			
		F : state<=G;
			 
		G : state<=H;
			
		H : state<=I;
				
		I : state<=J;
			
		J : state<=K;
			
		K : state<=A;
			
endcase	

end

always @ (state)
case (state)
	A: 
		data_out <= 0;
	B: 
		data_out <= 1;
	C:
 		data_out <= 0;
	D: 
		data_out <= 0;
	E: 
		data_out <= 1;
	F: 
		data_out <= 0;
	G: 
		data_out <= 1;
	H:
 		data_out <= 1;
	I: 
		data_out <= 0;
	J: 
		data_out <= 0;
	K: 
		data_out <= 1;
	

endcase


endmodule




module sequence_generator_fsm_tb;

reg clk = 0;
reg reset_n = 0;

wire data_out;

sequence_generator_fsm fsm(data_out, reset_n, clk);

// Set clock.
always #5 clk = ~clk;

// Test data.
initial begin
    $monitor($time, " data_out: %b, state: %b",
             data_out, fsm.state);

    #1 reset_n = 1;
    #200 $finish;
end

endmodule


