module sequence_detector_fsm_tb;

reg clk = 0;
reg reset_n = 0;
reg data_in = 0;

wire [1:0] data_out;

sequence_detector_fsm fsm(data_out, data_in, reset_n, clk);

// Set clock.
always #5 clk = ~clk;
always #10 $display($time, " reset_n: %b, data_in: %b, data_out: %b, state: %b",
                    reset_n, data_in, data_out, fsm.state);

// Test data.
initial begin
    #2 reset_n = 1;
    data_in = 0;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0;

    $finish;
end

endmodule

module sequence_detector_fsm(output reg [1:0] data_out, input data_in, input reset_n, input clk);


	reg		[2:0]state;
	
	
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;
	
	
	always @ (state) begin
		case (state)
			S0:
				data_out = 2'b00;
			S1:
				data_out = 2'b00;
			S2:
				data_out = 2'b00;
			S3:
				data_out = 2'b00;
			S4:
				data_out = 2'b01;
			default:
				data_out = 2'b00;
		endcase
	end
	
	
	always @ (posedge clk or posedge reset_n) begin
		if (reset_n)
			state <= S0;
		else
			case (state)
				S0:
					if (data_in)
						state <= S1;
					else
						state <= S0;				
				S1:
					if (data_in)
						state <= S2;
					else
						state <= S0;
				S2:
					if (data_in)
						state <= S3;
					else
						state <= S0;
				S3:
					if (data_in)
						state <= S4;
					else
						state <= S0;
				S4:
					if (data_in)
						state <= S4;
					else
						state <= S0;

			endcase
	end


endmodule