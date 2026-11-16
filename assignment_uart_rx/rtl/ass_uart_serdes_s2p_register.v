module ass_uart_serdes_s2p_register (
	input  clk, 
	input  rstb,
	input  sampling,
	input  ser_sync,
	input  [6:0] dev_addr,

	output addr_match,
	output [7:0] rx_shift_data
);

always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		rx_shift_data <= 8'b0;
	end else if(sampling) begin
		rx_shift_data <= {rx_shift_data[6:0], ser_sync};
	end
end

assign addr_match = (dev_addr == rx_shift_data[6:0]);

endmodule //: ass_uart_serdes_s2p_register