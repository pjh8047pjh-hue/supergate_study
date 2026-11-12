module sequence_detector_fsm (data_out, data_in, reset_n, clk);

output reg [2:0] data_out;

input data_in, clk, reset_n;

parameter A=3'b000, B=3'b001, C=3'b010, D=3'b011, E=3'b100;  
reg[2:0] state;
always @ (state)
begin
case (state)
	A: 
		data_out <= 0;
	B: 
		data_out <= 0;
	C:
 		data_out <= 0;
	D: 
		data_out <= 0;
	E: 
		data_out <= 1;
	default :
		 data_out <= 0;


	endcase

end

always @(posedge clk or negedge reset_n) 
begin
if (!reset_n)
	state <= A;
else 
	case (state)	
		A : if (data_in)
			state<=B;
			else state <= A; 
		B : if (data_in)
			state<=C;
			else state <= A;
		C : if (data_in)
			state<=D;
			else state <= A;	
		D : if (data_in)
			state<=E;
			else state <= A;
		E : if (data_in)
			state<=E;
			else state <= A;

	endcase
end
endmodule




module sequence_detector_fsm_tb;

reg clk = 0;
reg reset_n = 0;
reg data_in = 0;

wire data_out;

sequence_detector_fsm fsm(data_out, data_in, reset_n, clk);

// Set clock.
always #5 clk = ~clk;
always #10 $display($time, " reset_n: %b, data_in: %b, data_out: %b, state: %b",
                    reset_n, data_in, data_out, fsm.state);

// Test data.
initial begin
    #2 reset_n = 1;
    data_in = 0;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0;

    $finish;
end

endmodule
