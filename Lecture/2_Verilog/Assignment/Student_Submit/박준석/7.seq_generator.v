module seq_generator(data_out, reset_n, clk);

input clk, reset_n;
output reg data_out;

reg [3:0] state;

always @(posedge clk, negedge reset_n) begin
	if (!reset_n) state <= 0;
	else begin
		if (state < 10) state <= state + 1;
		else state <= 0;
	end
end

always @(state) begin
	case (state)
		0, 2, 3, 5, 8, 9:
			data_out = 0;
		1, 4, 6, 7, 10:
			data_out = 1;
		default:
			data_out = 0;	
	endcase		
end

endmodule
