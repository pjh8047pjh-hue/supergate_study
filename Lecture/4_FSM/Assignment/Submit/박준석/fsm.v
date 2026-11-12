module fsm(
	input clk, reset, in,
	output reg out
);

reg [2:0] current_state, next_state;
parameter A = 0;
parameter B = 1;
parameter C = 2;
parameter D = 3;
parameter E = 4;

always @(posedge clk or negedge reset) begin
	if (~reset) current_state <= A;
	else current_state <= next_state;			
end

always @(*) begin
	case (current_state)
		A: begin
			if(in) next_state = C;
			else next_state = B;
		end
		B: begin
			if(in) next_state = D;
			else next_state = B;
		end
		C: begin
			if(in) next_state = C;
			else next_state = E;
		end
		D: begin
			if(in) next_state = C;
			else next_state = E;
		end
		E: begin
			if(in) next_state = D;
			else next_state = B;
		end
		default: next_state = A;
	endcase
end

always @(*) begin
	case (current_state)
		A, B, C	: out = 0;
		D, E	: out = 1;
		default	: out = 0;
	endcase
end
endmodule
