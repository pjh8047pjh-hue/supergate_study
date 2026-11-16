module ass_uart_serdes (
	input  wire 	  clk,  
	input  wire 	  rstb,
	input  wire 	  ser_in,
	input  wire 	  ser_out,
	input  reg  [6:0] dev_addr,
	input  reg  [7:0] rdata,
	
	output wire	 	  rx_wen,
	output reg  [6:0] addr,
	output reg  [7:0] rx_wdata,
	output wire [1:0] cmd      
);
//=============================================================================
wire init;
wire bclk;

ass_uart_serdes_baud_gen u_baud_gen(
	.clk (clk),   
	.rstb(rstb),  
	.init(init),

	.bclk(bclk)
);
//=============================================================================
wire ser_fall;
wire ser_sync;

uart_edge_detecter u_edge_detecter(
	.clk 	 (clk),   s
	.rstb	 (rstb),  
	.ser_in  (ser_in),

	.ser_sync(ser_sync),
	.ser_fall(ser_fall),
);
//=============================================================================
wire [7:0] length;
wire data_en;
wire frame_done;
wire done;

ass_uart_serdes_fsm_counter u_fsm_counter(
	.clk 	   (clk), 
	.rstb  	   (rstb),
	.init	   (init),
	.bclk	   (bclk),
	.length	   (length),

	.data_en   (data_en),
	.frame_done(frame_done),
	.done 	   (done)
);
//=============================================================================
wire rdy;

ass_uart_serdes_fsm u_serdes_fsm(
	.clk 		(clk),   
	.rstb 		(rstb),
	.ser_rise 	(ser_rise),
	.ser_fall 	(ser_fall),
	.data_en	(data_en),
	.addr_match (addr_match),
	.done 		(done),
	
	.init 		(init),
	.init_cmd   (init_cmd),
	.init_addr  (init_addr),
	.init_length(init_length),
	.rdy 	 	(rdy)
);
//=============================================================================
module ass_uart_serdes_rx (
	.clk 		(clk), 
	.rstb 		(rstb), 
	.data_en	(data_en),
	.rdy 	 	(rdy),
	.init_cmd   (init_cmd),
	.init_addr  (init_addr),
	.init_length(init_length),
	.sampling   (sampling),
	.ser_sync   (ser_sync),
	.dev_addr   (dev_addr),
	
	.rx_wen  	(rx_wen),
	.addr_match (addr_match),
	.addr 		(addr),
	.rx_wdata  	(rx_wdata),
	.length  	(length),
	.cmd		(cmd)
);
endmodule //: ass_uart_serdes