module ass_uart_serdes_fsm_tx (
	input  clk,   
	input  rstb,
	input  data_en,
    input  tx_empty,
	
	output start,
    output tx_busy
);

localparam IDLE     = 1'b0;
localparam TRANSMIT = 1'b1;
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
		IDLE    : nstate = ~tx_empty ? TRANSMIT : IDLE;
		TRANSMIT: nstate =  data_en  ? IDLE     : TRANSMIT;
	endcase
end
//=============================================================================
assign tx_busy = (cstate == TRANSMIT);
assign start  = (cstate == IDLE) && ~tx_empty;

endmodule //: ass_uart_serdes_fsm
