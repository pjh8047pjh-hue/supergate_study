module clock_generator(new_clk, reset_n, clk);

input clk, reset_n;
output reg new_clk;

reg [15:0] counter;
reg signal;

always @(posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		counter <= 0;
		signal <= 0;
	end
	else begin
		counter <= counter + 1;
		if (counter == 16'd5000) begin
			signal <= ~signal;
			counter <= 0;
		end
	end
end

always @(posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		new_clk <= 0;
	end
	else begin
		if (signal) new_clk <= 1;
		else new_clk <= 0;
	end
end

endmodule
