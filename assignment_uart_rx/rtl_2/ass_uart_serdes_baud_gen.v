module ass_uart_serdes_baud_gen #(
    parameter [15:0] D_BAUD_LIMIT = 16'd2981
    parameter [15:0] D_BAUD_FREQ  = 16'd144
)(
	input clk,
	input rstb,
	input start,
	input rx_busy,

	output bclk
);
//=============================================================================
reg  [15:0] cnt_baud;

always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		cnt_baud <= 16'b0;
	end else if(start) begin
		cnt_baud <= 16'b0;
	end else if(bclk) begin
		cnt_baud <= cnt_baud - D_BAUD_LIMIT;
	end else begin
		cnt_baud <= cnt_baud + D_BAUD_FREQ;
	end
end

assign bclk = rx_busy && (cnt_baud >= D_BAUD_LIMIT);
//=============================================================================

endmodule// : ass_uart_serdes_baud_gen