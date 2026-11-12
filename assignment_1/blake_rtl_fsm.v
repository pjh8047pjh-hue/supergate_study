
module blake_rtl_fsm (
	input  wire clk,    
	input  wire ena,    
	input  wire rstb,   
	input  wire cnt_done,
	
	output wire init,
	output wire cnt_en,
	output wire done
);

localparam [1:0] IDLE = 2'b00;
localparam [1:0] RUN  = 2'b01;
localparam [1:0] DONE = 2'b10;

reg [1:0] cstate;
reg [1:0] nstate;

// current state
always @(posedge clk or negedge rstb) begin
	if (~rstb) begin
		cstate <= IDLE;
	end
	else begin
		cstate <= nstate;
	end
end

// next state
always @(*) 
begin
	case (cstate)
		IDLE   : nstate = (ena)     ? RUN : IDLE; //(ena && cstate == IDLE) ? RUN : IDLE;
		RUN    : nstate = (cnt_done)? DONE: RUN;
		DONE   : nstate = IDLE;
		default: nstate = IDLE;
	endcase
end

// output logic
assign init   = (cstate == IDLE) & ena; 
assign cnt_en = (cstate ==  RUN);
assign done   = (cstate == DONE);

endmodule //: blake_fsm
