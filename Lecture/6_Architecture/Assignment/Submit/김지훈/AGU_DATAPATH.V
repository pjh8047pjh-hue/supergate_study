module AGU_DATAPATH(clk, rst, ADDR, IMM, RF, OP, C0, C1, C6, C7, C2, C3, C4, C5);

	reg [15:0] AR0, AR1, BOT, TOP, STEP;

	output wire [15:0] ADDR;

    input [15:0] IMM, RF;
	input [3:0] OP;
	input clk, rst;
    input [1:0] C0, C1, C6, C7;
	input C2, C3, C4, C5;
	

	wire [15:0] newaddr, C7_out, AR_out, ALU_out;
	wire eq_out, newaddr_and;
	
	

	always @(posedge clk or negedge rst) begin

		if(!rst) begin

			AR0 <= 0;
		    AR1 <= 0;
		    BOT <= 0;
		    TOP <= 0;
		    STEP <= 0;
     
		end // if(!rst)

		else begin 

			case(C0)

				2 : AR0 <= newaddr;
				1 : AR0 <= RF;
				0 : AR0 <= AR0;

			endcase // C0

			case(C1)

				2 : AR1 <= newaddr;
				1 : AR1 <= RF;
				0 : AR1 <= AR1;

			endcase

			case(C2)

			    1 : BOT <= RF;
			    0 : BOT <= BOT;

			endcase

			case(C3)

				1 : TOP <= RF;
				0 : TOP <= TOP;

			endcase

			case(C4)

				1 : STEP <= RF;
				0 : STEP <= STEP;

			endcase

		end

	end



assign AR_out = (OP[0] == 0) ? AR0 : AR1;
assign C7_out = (C7 == 3) ? IMM : (C7 ==2) ? STEP : (C7 == 1) ? 1 : 0;
assign ALU_out = AR_out + C7_out;


assign eq_out = ( TOP == ALU_out );
assign newaddr_and = ( eq_out & C5 );


assign newaddr = ( newaddr_and ) ? BOT : ALU_out;


assign ADDR = ( C6 == 3 ) ? ALU_out : ( C6 == 2) ? AR_out : ( C6 == 1) ? RF : IMM;

endmodule 
 












		    





