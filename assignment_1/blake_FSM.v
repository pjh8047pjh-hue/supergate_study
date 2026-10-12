
module blake_FSM (
	input wire clk,    // Clock
	input wire ena,    // Clock Enable
	input wire rstb,   // Asynchronous reset active low
	input wire cnt_done,
	
	output reg cnt_en,
	output reg done
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

// next state logic
always @(*) begin
	nstate = cstate;

	case (cstate)
		IDLE : begin
			if(ena) nstate = RUN;
		end
		
		RUN  : begin
			if(cnt_done) begin
				nstate = DONE;
			end
		end

		DONE : begin
			nstate = IDLE;
		end

		default : begin
			nstate = IDLE;
		end
	endcase
end

// output logic
always @(*) begin
	cnt_en = 1'b0;
	done = 1'b0;

	if(~rstb) begin
		cnt_en = 0;
		done   = 0;
	end
	else begin
		case (cstate)
			IDLE : begin
				cnt_en = 0;
				done   = 0;
			end

			RUN  : begin
				cnt_en = 1;
				done   = 0;
			end

			DONE : begin
				cnt_en = 0;
				done   = 1;
			end

			default : begin
				cnt_en = 0;
				done   = 0;
			end
		endcase
	end
end

endmodule 
