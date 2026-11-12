module watchmaker(new_clk, clk, reset_n);

input clk, reset_n;
output reg new_clk;

reg [15:0] counter;
reg signal;

parameter count_num = 1;

always @(posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		counter <= 0;
		signal <= 1;
	end
	else begin
		if (counter == (count_num)/2 - 1) begin
			signal <= ~signal;
			counter <= 0;
		end
		else counter <= counter + 1;
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
