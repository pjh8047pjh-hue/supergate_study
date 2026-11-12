
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

// Update the current state on each clock edge
always @(posedge clk or negedge rstb) begin
	if (~rstb) begin
		cstate <= IDLE;
	end
	else begin
		cstate <= nstate;
	end
end

wire busy_g0, busy_g1;
wire g0_end, g1_end;
wire g0_avaliable, g1_avaliable;

// Indicate which G is running
assign busy_g0 = cstate[0]; // (cstate == RUN_G0) or (cstate == RUN_BOTH)
assign busy_g1 = cstate[1]; // (cstate == RUN_G1) or (cstate == RUN_BOTH)

// Stop a completed G - no new input
assign g0_end = !ena && done_g0;
assign g1_end = !ena && done_g1;

// Accept a new input - G is avaliable
assign g0_avaliable = ena && !busy_g0;
assign g1_avaliable = ena && !busy_g1;

reg [1:0] next_idle;
reg [1:0] next_g0;
reg [1:0] next_g1;
reg [1:0] next_both;

// current state logic
always @(*) begin
    next_idle = IDLE;
    next_g0   = RUN_G0;
    next_g1   = RUN_G1;
    next_both = RUN_BOTH;

    // start G0 from IDLE
    if (ena) begin
        next_idle = RUN_G0; 
    end

    if (g1_avaliable && !done_g0) begin
        next_g0 = RUN_BOTH;        
    end
    if (g0_avaliable && !done_g1) begin
        next_g1 = RUN_BOTH;
    end

    // G0 finishes: go to IDLE or RUN_G1
    if (g0_end) begin
        next_g0   = IDLE;
        next_both = RUN_G1;
    end

    // G1 finishes: go to IDLE or RUN_G0
    if (g1_end) begin
        next_g1   = IDLE;
        next_both = RUN_G0;
    end
end

// next state logic 
always @(*) begin
    case (cstate)
        IDLE:     nstate = next_idle;
        RUN_G0:   nstate = next_g0;
        RUN_G1:   nstate = next_g1;
        RUN_BOTH: nstate = next_both;
        default:  nstate = cstate;
    endcase
end

// output logic
assign cnt_en_g0 = busy_g0;
assign cnt_en_g1 = busy_g1;

assign init_g0 = ena && !done_g1 && (!busy_g0 || done_g0);
assign init_g1 = ena && !done_g0 && (done_g1  || (cstate == RUN_G0));

endmodule //: blake_fsm