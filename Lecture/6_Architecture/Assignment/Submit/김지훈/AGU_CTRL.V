module AGU_CTRL(C0, C1, C2, C3, C4, C5, C6, C7, OP);

	output reg [1:0] C0, C1, C6, C7;
	output reg C2, C3, C4, C5;

	input [3:0] OP;



	always @(*) begin

		case(OP)


			4'b0000 : begin
  
			   C0 = 2'd1;
			   C1 = 2'd0;
			   C2 = 1'd0;
			   C3 = 1'd0;
			   C4 = 1'd0;

			end


			4'b0001 : begin

			 	C0 = 2'd0;
			 	C1 = 2'd1;
			 	C2 = 1'd0;
			    C3 = 1'd0;
			    C4 = 1'd0;

			end

			4'b0010 : begin

				C0 = 2'd0;
				C1 = 2'd0;
				C2 = 1'd0;
				C3 = 1'd0;
				C4 = 1'd1;

			end // 3'b0010 :

			4'b0100 : begin

				C0 = 2'd0;
				C1 = 2'd0;
				C2 = 1'd0;
				C3 = 1'd0;
				C4 = 1'd0;

				C6 = 2'd0;

			end // 3'b0100 :

			4'b0101 : begin

				C0 = 2'd0;
				C1 = 2'd0;
				C2 = 1'd0;
				C3 = 1'd0;
				C4 = 1'd0;

				C6 = 2'd1;

			end // 3'b0101 :

			4'b0110 : begin

				C0 = 2'd2;
				C1 = 2'd0;
				C2 = 1'd0;
				C3 = 1'd0;
				C4 = 1'd0;

				C5 = 1'd0;
				C6 = 2'd2;
				C7 = 2'd2;

			end // 3'b0110 :

			4'b0111 : begin

				C0 = 2'd0;
				C1 = 2'd2;
				C2 = 1'd0;
				C3 = 1'd0;
				C4 = 1'd0;

				C5 = 1'd0;
				C6 = 2'd2;
				C7 = 2'd2;

			end // 3'b0110 :

			4'b1000 : begin

				C0 = 2'd0;
				C1 = 2'd0;
				C2 = 1'd0;
				C3 = 1'd0;
				C4 = 1'd0;

				C6 = 2'd3;
				C7 = 2'd3;

			end // 3'b0110 :

			4'b1001 : begin

				C0 = 2'd0;
				C1 = 2'd0;
				C2 = 1'd0;
				C3 = 1'd0;
				C4 = 1'd0;

				C6 = 2'd3;
				C7 = 2'd3;

			end // 3'b0110 :

			4'b1010 : begin

				C0 = 2'd2;
				C1 = 2'd0;
				C2 = 1'd0;
				C3 = 1'd0;
				C4 = 1'd0;

				C5 = 1'd1;
				C6 = 2'd2;
				C7 = 2'd1;

			end // 3'b0110 :

			4'b1011 : begin

				C0 = 2'd0;
				C1 = 2'd2;
				C2 = 1'd0;
				C3 = 1'd0;
				C4 = 1'd0;
				
				C5 = 1'd1;
				C6 = 2'd2;
				C7 = 2'd1;

			end // 3'b0110 :

			4'b1110 : begin

				C0 = 2'd0;
				C1 = 2'd0;
				C2 = 1'd0;
				C3 = 1'd1;
				C4 = 1'd0;

			end // 3'b0110 :

			4'b1111 : begin

				C0 = 2'd0;
				C1 = 2'd0;
				C2 = 1'd0;
				C3 = 1'd1;
				C4 = 1'd0;
				
			end // 3'b0110 :

			default: begin

			    C0 = 0;
			    C1 = 0;
			    C2 = 0;
			    C3 = 0;
			    C4 = 0;
			    C5 = 0;
			    C6 = 0;
			    C7 = 0;

		    end // default

		endcase // op

	end

endmodule // AGU_CTRL
















