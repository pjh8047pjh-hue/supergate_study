module ass_i2c_slave_serdes #(
    parameter [6:0] device_address = 7'h45
)(
	input  clk, 
	input  rstb,
	input  scl,
	input  sda,	
	input  [7:0] tx_rdata_in,
	input  rx_full,
	input  tx_empty,


	output start,
	output stop,
	output rx_wen,
	output req,
	output tx_ren,
	output stop_nack,
	output reg [7:0] rx_wdata,
	output sda_oe
);

//=============================================================================
wire scl_rise;
wire scl_fall;
wire sda_rise;
wire sda_fall;
wire [1:0] sda_d2;
wire [1:0] scl_d2; 

edge_detecter u_edge(
	.clk 	 (clk),   
	.rstb  	 (rstb),  
	.sda 	 (sda),
	.scl 	 (scl),

	.scl_fall(scl_fall),
	.scl_rise(scl_rise),
	.sda_fall(sda_fall),
	.sda_rise(sda_rise),
	.stop	 (stop),
	.start	 (start),
	.sda_d2  (sda_d2),
	.scl_d2  (scl_d2)
);
//=============================================================================

//=============================================================================
// register block
wire rx_en;
reg  [7:0] tx_rdata;
wire cnt_max;

// I2C to bit : write data register
always @(posedge clk or negedge rstb) begin
    if (!rstb)
        rx_wdata <= 8'b0;
    else if (rx_en)
        rx_wdata <= {rx_wdata[6:0], sda_d2[1]};
end

// bit to I2C
always @(posedge clk or negedge rstb) begin
    if (!rstb)
        tx_rdata <= 8'b0;
    else if (cnt_max && !tx_empty)
        tx_rdata <= tx_rdata_in;
end
//=============================================================================
wire init_0;
wire cnt_inc;
wire [3:0] cnt_scl;

ass_i2c_slave_scl_counter u_scl_counter(
	.clk    (clk),  
	.rstb   (rstb),  
	.init_0 (init_0),
	.cnt_inc(cnt_inc),
	.cnt_max(cnt_max),
	.cnt_scl(cnt_scl)
);
//=============================================================================
ass_i2c_slave_serdes_fsm #(.device_address(device_address)) u_serdes_fsm(
	.clk	    (clk),  
	.rstb	    (rstb), 
	.start	    (start),
	.stop	    (stop),
	.scl_rise   (scl_rise),
	.scl_fall   (scl_fall),
	.rx_wdata   (rx_wdata),
	.tx_rdata   (tx_rdata),
	.ack_bit    (sda_d2[1]),
	.cnt_scl    (cnt_scl),
	.rx_full    (rx_full),
	.tx_empty   (tx_empty),

	.tx_ren 	(tx_ren),
	.stop_nack  (stop_nack),
	.cnt_inc    (cnt_inc),
	.cnt_max    (cnt_max),
	.init_0     (init_0),
	.rx_en      (rx_en),
	.rx_wen	    (rx_wen), 
	.req	    (req),
	.sda_oe	    (sda_oe)
);
//=============================================================================

endmodule //: ass_i2c_slave_serdes
