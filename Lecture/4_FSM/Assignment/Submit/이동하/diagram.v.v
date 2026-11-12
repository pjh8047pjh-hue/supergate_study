module diagram(output reg [1:0] data_out, input data_in, input reset_n, input clk);

reg [3:0] state = 4'ha;
parameter A = 10, B = 11, C = 12, D = 13, E = 14;
	
always @ (state) begin
	case (state)
		A:
			data_out = 2'b00;
		B:
			data_out = 2'b00;
		C:
			data_out = 2'b00;
		D:
			data_out = 2'b01;
		E:
			data_out = 2'b01;
		default:
			data_out = 2'b00;
	endcase
end
	
always @ (posedge clk or posedge reset_n) begin
	if (reset_n)
		state <= A;
	else
		case (state)
			A:
				if (data_in)
					state <= C;
				else
					state <= B;				
			B:
				if (data_in)
					state <= D;
				else
					state <= B;
			C:
				if (data_in)
					state <= C;
				else
					state <= E;
			D:
				if (data_in)
					state <= C;
				else
					state <= E;
			E:
				if (data_in)
					state <= D;
				else
					state <= B;
		endcase
end

endmodule