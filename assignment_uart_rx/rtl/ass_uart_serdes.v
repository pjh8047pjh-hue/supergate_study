module ass_uart_serdes (
	input  wire 	  clk,  
	input  wire 	  rstb,
	input  wire 	  ser_in,
	input  wire 	  ser_out,
	input  reg  [6:0] dev_addr,
	input  reg  [7:0] rdata,
	
	output wire	 	  we,
	output reg  [6:0] addr,
	output reg  [7:0] wdata,
);



endmodule //: ass_uart_serdes