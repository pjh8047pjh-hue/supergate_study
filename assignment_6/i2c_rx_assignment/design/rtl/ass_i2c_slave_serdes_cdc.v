module ass_i2c_slave_serdes_cdc (
	input  clk, 
	input  rstb,
	input  ack_out_req,
	input  ack_out_start,
	input  ack_out_stop,

	output ack_req_sync,
	output ack_start_sync,
	output ack_stop_sync
); 


cdc_handshake_sync u_cdc_ack_req(
    .clk	 (clk), 
    .rstb	 (rstb),
    .req_in   (ack_out_req),
    .ack_out  (ack_req_sync),
    .req_pulse()
);

cdc_handshake_sync u_cdc_ack_start(
    .clk	 (clk), 
    .rstb	 (rstb),
    .req_in   (ack_out_start),
    .ack_out  (ack_start_sync),
    .req_pulse()
);

cdc_handshake_sync u_cdc_ack_stop(
    .clk	 (clk), 
    .rstb	 (rstb),
    .req_in   (ack_out_stop),
    .ack_out  (ack_stop_sync),
    .req_pulse()
);
endmodule // : ass_i2c_slave_serdes_cdc
