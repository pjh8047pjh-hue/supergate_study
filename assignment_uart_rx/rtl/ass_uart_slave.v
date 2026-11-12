//---------------------------------------------------------------------------------------
// uart to internal bus top module
//
//---------------------------------------------------------------------------------------

module ass_uart_slave
(
	// Device address
	input  wire [6:0] dev_adr
	input  wire       clk,	// global clock input
	input  wire       rstb,	// global reset input
	
	// UART I/O signals
	input  wire	ser_in,	    // serial data input
	output wire	ser_out, 	// serial data output
);


endmodule