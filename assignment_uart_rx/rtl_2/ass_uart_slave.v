//---------------------------------------------------------------------------------------
// uart to internal bus top module
//
//---------------------------------------------------------------------------------------

module ass_uart_slave
(
	// Device address
	input  wire [6:0] dev_adr,
	input  wire       clk_1,
	input  wire       clk_2,	// global clock input
	input  wire       rstb,	// global reset input
	
	// UART I/O signals
	input  wire	ser_in,	    // serial data input
	output wire	ser_out 	// serial data output
);
//=============================================================================
wire rx_full;
wire tx_empty;
wire tx_ren;
wire rx_wen;
wire [7:0] tx_rdata; 
wire [7:0] rx_wdata;

ass_uart_serdes u_serdes(
	.clk 	 (clk_1),  
	.rstb    (rstb),
	.ser_in  (ser_in),
	.rx_full (rx_full),
	.tx_empty(tx_empty),
	.tx_rdata(tx_rdata),
	
	.ser_out (ser_out),
	.tx_ren  (tx_ren),
	.rx_wen  (rx_wen),
	.rx_wdata(rx_wdata)
);
//=============================================================================
wire rx_ren;
wire tx_wen;
wire rx_empty;
wire tx_full;
wire [7:0] rx_rdata;
wire [7:0] tx_wdata;

generic_fifo_dc u_rx_fifo(
    .rd_clk (clk_2), 
    .wr_clk (clk_1), 
    .rst    (rstb), 
    .clr    (), 
    .din    (rx_wdata),
    .we     (rx_wen), 
    .dout   (rx_rdata),
    .re     (rx_ren),
    .full   (rx_full), 
    .empty  (rx_empty), 
    .full_n (),
    .empty_n(), 
    .level  () 
);

generic_fifo_dc u_tx_fifo(
    .rd_clk (clk_1), 
    .wr_clk (clk_2), 
    .rst    (rstb),
    .clr    (), 
    .din    (tx_wdata),
    .we     (tx_wen), 
    .dout   (tx_rdata),
    .re     (tx_ren),
    .full   (tx_full), 
    .empty  (tx_empty), 
    .full_n (), 
    .empty_n(), 
    .level  () 
);
//=============================================================================
wire       we;
wire [6:0] addr;
wire [7:0] wdata;
wire [7:0] rdata;

ass_uart_slave_rf_v2 u_rf(
    .clk   (clk_2),
    .addr  (addr),
    .wdata (wdata),
    .we    (we),

    .rdata (rdata)
);

endmodule
