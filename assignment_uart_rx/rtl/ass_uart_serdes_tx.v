module ass_uart_serdes_tx (
	input clk,  
	input rstb,
	input tx_empty,
	input tx_rdata, 
	
	output tx_ren,	
	output ser_out
);

/*
idle -> start -> command -> addr(16 bit) -> length
*/

localparam IDLE    = 3'b000;
localparam START   = 3'b001;
localparam COMMAND = 3'b010;
localparam ADDR    = 3'b011;
localparam LENGTH  = 3'b100;
localparam DATA    = 3'b101;


endmodule //: ass_uart_serdes_tx