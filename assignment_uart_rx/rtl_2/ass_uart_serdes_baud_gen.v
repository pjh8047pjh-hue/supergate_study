module ass_uart_serdes_baud_gen (
	input clk,
	input rstb,
	input start,
	input rx_busy,
    input [15:0] baud_freq,
    input [15:0] baud_limit,

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
		cnt_baud <= cnt_baud - baud_limit;
	end else begin
		cnt_baud <= cnt_baud + baud_freq;
	end
end

assign bclk = rx_busy && (cnt_baud >= baud_limit);
//=============================================================================

endmodule// : ass_uart_serdes_baud_gen
