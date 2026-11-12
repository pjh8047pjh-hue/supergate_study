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

two_level_1bit_synchronizer u_2_level_sync_req(
    .clk 	 (clk),
    .data_in (req),
    .data_out(req_sync)
);

two_level_1bit_synchronizer u_2_level_sync_start(
    .clk 	 (clk),
    .data_in (start),
    .data_out(start_sync)
);

two_level_1bit_synchronizer u_2_level_sync_stop(
    .clk 	 (clk),
    .data_in (stop_nack),
    .data_out(stop_sync)
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