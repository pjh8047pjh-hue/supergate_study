module ass_uart_serdes (
	input  wire 	  clk,  
	input  wire 	  rstb,
	input  wire 	  ser_in,
	input  wire 	  rx_full,
	input  wire   	  tx_empty,
	input  reg  [7:0] tx_rdata,
	
	output wire 	  ser_out,
	output wire  	  tx_ren,
	output wire	 	  rx_wen,
	output reg  [7:0] rx_wdata
);
//=============================================================================
wire ser_fall;
wire ser_sync;

uart_edge_detecter u_edge_detecter(
	.clk 	 (clk),   
	.rstb	 (rstb),  
	.ser_in  (ser_in),

	.ser_sync(ser_sync),
	.ser_fall(ser_fall)
);
//=============================================================================
wire rx_sampling;
wire rx_start;
wire rx_busy;
wire rx_bclk;
wire rx_data_en;

ass_uart_serdes_baud_gen u_baud_gen_rx(
	.clk    (clk),   
	.rstb   (rstb),  
	.start  (rx_start),
	.rx_busy(rx_busy),

	.bclk   (rx_bclk)
);

ass_uart_serdes_fsm_rx u_fsm_rx(
	.clk 	 (clk),   
	.rstb 	 (rstb),
	.ser_rise(ser_rise),
	.ser_fall(ser_fall),
	.rx_full (rx_full),
	.data_en (rx_data_en),

	.start 	 (rx_start),
	.rx_busy (rx_busy)
);

ass_uart_serdes_counter u_couter_rx(
	.clk 	  (clk), 
	.rstb 	  (rstb),
	.start    (rx_start),
	.bclk 	  (rx_bclk),

	.data_en  (rx_data_en),
	.tx_update(),
	.sampling (rx_sampling),
	.cnt_bit  ()

);

ass_uart_serdes_shift_reg_s2p u_shift_reg_s2p(
    .clk 		 (clk),
    .rstb 		 (rstb),
    .sampling 	 (rx_sampling),
    .serial_in   (ser_sync),
    .data_en  	 (rx_data_en),

    .parallel_out(rx_wdata)
);

assign rx_wen = ~rx_full && rx_data_en;
//=============================================================================
wire tx_start;
wire tx_bclk;
wire [3:0] tx_cnt_bit;
wire tx_update;
wire tx_data_en;

ass_uart_serdes_baud_gen u_baud_gen_tx(
	.clk  (clk),   
	.rstb (rstb),  
	.start(tx_start),
	.rx_busy(),

	.bclk (tx_bclk)
);

ass_uart_serdes_fsm_tx u_fsm_tx(
	.clk 	 (clk),   
	.rstb    (rstb),
	.data_en (tx_data_en),
    .tx_empty(tx_empty),
	
	.start   (tx_start)
);

assign tx_ren = tx_start;

ass_uart_serdes_counter u_couter_tx(
	.clk 	  (clk), 
	.rstb 	  (rstb),
	.start    (tx_start),
	.bclk 	  (tx_bclk),

	.data_en  (tx_data_en),
	.tx_update(tx_update),
	.sampling (tx_sampling),
	.cnt_bit  (tx_cnt_bit)
);

ass_uart_serdes_shift_reg_p2s u_shift_reg_p2s(
    .clk 		(clk),
    .rstb  	    (rstb),
    .start 	    (tx_start),
    .parallel_in(tx_rdata),
    .cnt_bit    (tx_cnt_bit),
    .data_en    (tx_data_en),

    .serial_out (ser_out)
);
endmodule