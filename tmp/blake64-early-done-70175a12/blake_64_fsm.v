
module blake_64_fsm (
	input  wire clk,    
	input  wire ena,    
	input  wire rstb,   
	input  wire done_g0,
	input  wire done_g1,
	
	output wire init_g0,
	output wire init_g1,
	output wire cnt_en_g0,
	output wire cnt_en_g1
);

localparam [1:0] IDLE     = 2'b00;
localparam [1:0] RUN_G0   = 2'b01;
localparam [1:0] RUN_G1   = 2'b10;
localparam [1:0] RUN_BOTH = 2'b11;

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

// next state ============================
wire busy_g0, busy_g1;

assign busy_g0 = cstate[0];
assign busy_g1 = cstate[1];

assign g0_end = !ena && done_g0;
assign g1_end = !ena && done_g1;

assign g0_avaliable = ena && !busy_g0; 
assign g1_avaliable = ena && !busy_g1;

always @(*) begin
	nstate = cstate;

	case (cstate)
		IDLE    : nstate = (ena) ? RUN_G0 : IDLE;
		RUN_G0  : begin 
			if(g1_avaliable && !done_g0) begin
				nstate = RUN_BOTH;
			end
			if(g0_end) begin
				nstate = IDLE;
			end 		 
		end
		RUN_G1  : begin
			if(g0_avaliable && !done_g1) begin
				nstate = RUN_BOTH;
			end
			if(g1_end) begin
				nstate = IDLE;
			end		 
		end
		RUN_BOTH: begin
			if(g0_end) nstate = RUN_G1;
			if(g1_end) nstate = RUN_G0;
		end
		default : nstate = cstate;
	endcase
end
//=========================================

// output logic
assign cnt_en_g0 = busy_g0;
assign cnt_en_g1 = busy_g1;

assign init_g0 = ena && !done_g1 && (!busy_g0 || done_g0);
assign init_g1 = ena && !done_g0 && (done_g1  || (cstate == RUN_G0));
endmodule //: blake_fsm
