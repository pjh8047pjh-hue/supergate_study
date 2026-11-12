module ass_i2c_slave_pkg_dec (
	input clk,  
	input rstb,
	input req,
	input start,
	input stop_nack,
	input rx_empty,
	input tx_full,
	input [7:0] rx_rdata,
	input [7:0] rdata,
	


	output ack_out_req,
	output ack_out_start,
	output ack_out_stop,
	output tx_wen,
	output rx_ren,
	output reg  [7:0] addr,
	output wire [7:0] wdata,
	output wire [7:0] tx_wdata,
	output we
);
//=============================================================================
wire req_sync;
wire start_sync;
wire stop_sync;

one_bit_cdc_cntl u_cdc_req(
    .clk	 (clk), 
    .rstb	 (rstb),
    .cntl_in (req),
    .ack_out (ack_out_req),
    .cntl_out(req_sync)
);

one_bit_cdc_cntl u_cdc_start(
    .clk	 (clk), 
    .rstb	 (rstb),
    .cntl_in (start),
    .ack_out (ack_out_start),
    .cntl_out(start_sync)

);one_bit_cdc_cntl u_cdc_stop(
    .clk	 (clk), 
    .rstb	 (rstb),
    .cntl_in (stop),
    .ack_out (ack_out_stop),
    .cntl_out(stop_sync)
);
//=============================================================================
wire addr_inc;
wire waddr_en;

ass_i2c_slave_pkg_dec_fsm u_pkg_fsm(
	.clk	  (clk),  
	.rstb	  (rstb),
	.rx_empty (rx_empty),
	.req	  (req_sync),
	.start	  (start_sync),
	.stop_nack(stop_sync),
	.tx_full  (tx_full),

	.rx_ren   (rx_ren),
	.tx_wen   (tx_wen),
	.addr_inc (addr_inc),
	.waddr_en (waddr_en),
	.we  	  (we)
);
//=============================================================================
// addr setting logic

always @(posedge clk or negedge rstb) begin
    if (~rstb)
        addr <= 8'b0;
    else if (waddr_en) begin
        addr <= rx_rdata;
    end    
    else if (addr_inc) begin
        addr <= addr + 1'b1;
	end
end

//wdata register

assign wdata    = we ? rx_rdata : rdata;
assign tx_wdata = tx_wen ? wdata : 8'b0;
//=============================================================================

endmodule //: ass_i2c_slave_pkg_dec