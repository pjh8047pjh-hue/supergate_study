module ass_i2c_slave_pkg_dec_fsm (
	input  clk,  
	input  rstb,
	input  start,
	input  stop_nack,
	input  req,
	input  rx_empty,
	input  tx_full,

	output rx_ren,
	output tx_wen,
	output waddr_en,
	output addr_inc,
	output we
);

//=============================================================================
//FSM
localparam IDLE  = 2'd0;
localparam START = 2'd1;
localparam READ  = 2'd2;
localparam WRITE = 2'd3;

reg [1:0] cstate;
reg [1:0] nstate;
//=============================================================================
// current state logic
always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		cstate <= IDLE;
	end else begin
		cstate <= nstate;
	end
end
//=============================================================================
// next state logic
always @(*) begin
	nstate = cstate;

	// exit READ state
	if(stop_nack) begin
		nstate = IDLE;
	end
	else if(start) begin
		nstate = START;
	end 
	else begin
		case(cstate)
			IDLE  : nstate = IDLE;
			START : nstate = req ? READ : (~rx_empty ? WRITE : START);
			READ  : nstate = READ;
			WRITE : nstate = WRITE;
		endcase
	end
end
//=============================================================================
// output logic
assign rx_ren   = ~rx_empty;
assign tx_wen   = ~tx_full && req;
assign waddr_en = (cstate == START) && ~rx_empty;
assign addr_inc = req || (~rx_empty && (cstate == WRITE));
assign we       = (cstate == WRITE) && ~rx_empty;
//=============================================================================

endmodule //: ass_i2c_slave_pkg_dec_fsm