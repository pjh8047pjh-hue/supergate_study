module traffic_ctrl(hw, fw, X, clk, rst);

input clk, rst, X;
output reg [1:0] hw, fw;

reg [2:0] current_state, next_state;

parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
parameter RED = 0, YELLOW = 1, GREEN = 2;

always @(posedge clk or negedge rst) begin
	if (!rst) current_state <= S0;
	else current_state <= next_state;
end

always @(*) begin
	case (current_state)
		S0: begin
			if(X) next_state = S1;
			else next_state = S0;
		end
		S1: next_state = S2;
		S2: begin
			if(X) next_state = S2;
			else next_state = S3;
		end
		S3: next_state = S0;
		default: next_state = S0;
	endcase
end

always @(*) begin
	case (current_state)
		S0: begin
			hw = GREEN;
			fw = RED;
		end
		S1: begin
			hw = YELLOW;
			fw = RED;
		end
		S2: begin
			hw = RED;
			fw = GREEN;
		end
		S3: begin
			hw = RED;
			fw = YELLOW;
		end
		default: begin
			hw = RED;
			fw = RED;
		end
	endcase
end
endmodule
