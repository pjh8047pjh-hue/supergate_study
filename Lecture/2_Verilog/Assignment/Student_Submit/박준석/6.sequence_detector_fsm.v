module sequence_detector_fsm(data_out, data_in, reset_n, clk);

input data_in, reset_n, clk;
output reg data_out;

reg [2:0] state;

always @(posedge clk or negedge reset_n) begin
	if(!reset_n)
		state <= 0;
	else begin
		case (state)
			0, 1, 2, 3:
				if (data_in)
					state <= state + 1;
				else
					state <= 0;
			4:
				if (data_in)
					state <= 4;
				else
					state <= 0;
			default:
				state <= 0;
		endcase
	end
end

always @(state) begin
	case (state)
		0, 1, 2, 3:
			data_out = 0;
		4:
			data_out = 1;
		default:
			data_out = 0;
	endcase
end

endmodule
