
module sig_control(hwy, fwy, X, clock, clear);
output[1:0] hwy, fwy;
reg [1:0] hwy, fwy;
input X;
input clock, clear;
parameter RED = 2'd0, YELLOW = 2'd1, GREEN = 2'd2;
parameter S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3;
reg [2:0] state;
reg [2:0] next_state;
always @(posedge clock)
if(clear)
state <=S0;
else
state <= next_state;
always @(state)
	begin 
	 hwy = GREEN;
	 fwy = RED;
 		case (state)
		S0: ;
		S1:hwy = YELLOW;
		S2:	begin
		hwy = RED;
		fwy = YELLOW;
			end
		endcase
	end

always @(state or X)
	begin
		case (state)
		S0: if (X)
		next_state = S1;
		else
		next_state = S0;	
		S1: begin 
			repeat(3)@ (posedge clock);
		next_state = S2;
		    end
		S2: if (X)
		next_state = S2;
		    else
		next_state = S3;
		S3: begin
			repeat(3) @(posedge clock);
		next_state = S0;
		    end
		default: next_state = S0;
		endcase
	end
endmodule


