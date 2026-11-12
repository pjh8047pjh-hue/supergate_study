module ass_i2c_slave_pkg_dec (
	input clk,  
	input rstb,
	input start_req,
	input stop_req,
	input req,
	input rx_empty,	
	input tx_full,
	input [7:0] rx_rdata,
	input [7:0] rdata,
	
	output ack_out_req,
	output ack_out_start,
	output ack_out_stop,
	output rx_ren,
	output tx_wen,
	output we,
	output reg  [7:0] addr,	
	output wire [7:0] tx_wdata,
	output wire [7:0] wdata
);
//=============================================================================
wire req_sync;
wire start_sync;
wire stop_sync;

cdc_handshake_sync u_cdc_req(
    .clk	  (clk), 
    .rstb	  (rstb),
    .req_in   (req),
    .ack_out  (ack_out_req),
    .req_pulse(req_sync)
);

cdc_handshake_sync u_cdc_start(
    .clk      (clk),
    .rstb     (rstb),
    .req_in   (start_req),
    .ack_out  (ack_out_start),
    .req_pulse(start_sync)
);

cdc_handshake_sync u_cdc_stop(
    .clk      (clk),
    .rstb     (rstb),
    .req_in   (stop_req),
    .ack_out  (ack_out_stop),
    .req_pulse(stop_sync)
);

//=============================================================================
wire addr_inc;
wire waddr_en;

ass_i2c_slave_pkg_dec_fsm u_pkg_fsm(
	.clk	  (clk),  
	.rstb	  (rstb),
	.start	  (start_sync),
	.stop_nack(stop_sync),
	.req	  (req_sync),
	.rx_empty (rx_empty),
	.tx_full  (tx_full),

	.rx_ren   (rx_ren),
	.tx_wen   (tx_wen),
	.waddr_en (waddr_en),
	.addr_inc (addr_inc),
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