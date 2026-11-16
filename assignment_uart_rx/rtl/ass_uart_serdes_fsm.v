module ass_uart_serdes_fsm (
	input  clk,   
	input  rstb,
	input  ser_rise,
	input  ser_fall,
	input  data_en,
	input  addr_match,
	input  done,
	
	output init,
	output init_cmd,
	output init_addr,
	output init_length,
	output rdy
);

localparam IDLE    = 3'b000;
localparam START   = 3'b001;
localparam COMMAND = 3'b010;
localparam CHECK   = 3'b011;
localparam ADDR    = 3'b100;
localparam LENGTH  = 3'b101;
localparam READ    = 3'b110;
localparam WRITE   = 3'b111;
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
always @(posedge clk) begin
	nstate = cstate;

	case(cstate) 
		IDLE   : nstate = start ? START : IDLE;
		START  : nstate = start ? COMMAND : START;
		CHECK  : nstate = start && addr_match ? ADDR : IDLE;
		ADDR   : nstate = start ? LENGTH : ADDR;
		LENGTH : nstate = start && cmd ? READ : WRITE;
		READ   : nstate = done  ? IDLE : READ;
		WRITE  : nstate = done  ? IDLE : WRITE;
	endcase
end
//=============================================================================
assign init        = (cstate == IDLE   ) && ser_fall;
assign init_cmd    = (cstate == COMMAND) && data_en;
assign init_addr   = (cstate == ADDR   ) && data_en;
assign init_length = (cstate == LENGTH ) && data_en;
assign rdy 	   = (cstate == ADDR   ) || (cstate == WRITE  ) && data_en;
//=============================================================================

endmodule //: ass_uart_serdes_fsm