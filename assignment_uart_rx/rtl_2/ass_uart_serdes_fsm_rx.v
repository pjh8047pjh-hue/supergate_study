module ass_uart_serdes_fsm_rx (
	input  clk,   
	input  rstb,
	input  ser_rise,
	input  ser_fall,
	input  rx_full,
	input  data_en,
	
	output start,
	output rx_busy
);

localparam IDLE    = 1'b0;
localparam RECEIVE = 1'b1;
//=============================================================================
reg [2:0] cstate;
reg [2:0] nstate;

always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		cstate <= IDLE;
	end else begin
		cstate <= nstate;
	end
end
//=============================================================================

//=============================================================================
always @(*) begin
	nstate = cstate;

	case(cstate)
		IDLE   : nstate = start && ~rx_full ? RECEIVE : IDLE;
		RECEIVE: nstate = data_en ? IDLE : RECEIVE;
	endcase
end
//=============================================================================
assign start   = (cstate == IDLE) && ser_fall;
assign rx_busy = (cstate == RECEIVE); 
//=============================================================================

endmodule //: ass_uart_serdes_fsm