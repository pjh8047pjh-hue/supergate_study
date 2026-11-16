module ass_uart_serdes_data_register (
	input  clk,  
	input  rstb,
	input  data_en,
	input  init_cmd,
	input  init_addr,
	input  init_length,
	input  [7:0] rx_shift_data,

	output reg [6:0] addr,
	output reg [7:0] wdata,
	output reg [7:0] length,
	output reg [1:0] cmd
);

always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		addr <= 7'b0;
	end else if(init_addr) begin
		addr <= rx_shift_data[6:0];
	end
end

always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		cmd <= 2'b0;
	end else if(init_cmd) begin
		cmd <= rx_shift_data[5:4];
	end
end

always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		length <= 8'b0;
	end else if(init_length) begin
		length <= rx_shift_data;
	end
end

always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		wdata <= 8'b0;
	end else if(data_en) begin
		wdata <= rx_shift_data;
	end
end

endmodule //: ass_uart_serdes_data_register