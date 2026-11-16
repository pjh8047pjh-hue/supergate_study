module ass_uart_serdes_rx (
	input  clk, 
	input  rstb, 
	input  data_en,
	input  init_cmd,
	input  init_addr,
	input  init_length,
	input  sampling,
	input  ser_sync,
	input  rdy,
	input  rx_full,
	input  [6:0] dev_addr,

	output rx_wen,
	output addr_match,
	output [6:0] addr,
	output [7:0] rx_wdata,
	output [7:0] length,
	output [1:0] cmd	
);
//=============================================================================
wire [7:0] rx_shift_data;

ass_uart_serdes_s2p_register u_s2p_register(
	.clk	   	  (clk), 
	.rstb  	   	  (rstb),
	.sampling  	  (sampling),
	.ser_sync  	  (ser_sync),
	.dev_addr  	  (dev_addr),

	.addr_match   (addr_match),
	.rx_shift_data(rx_shift_data)
);
//=============================================================================
ass_uart_serdes_data_register u_data_register(
	.clk          (clk),  
	.rstb		  (rstb),
	.data_en      (data_en),
	.init_cmd     (init_cmd),
	.init_addr    (init_addr),
	.init_length  (init_length),
	.rx_shift_data(rx_shift_data),

	.addr 		  (addr),	
	.wdata 		  (rx_wdata),
	.length 	  (length),
	.cmd 		  (cmd)
);
//=============================================================================
assign rx_wen = rdy && ~rx_full;

endmodule //: ass_uart_serdes_rx