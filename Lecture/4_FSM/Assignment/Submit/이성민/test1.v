
module test1_tb;

reg clk = 0;
reg reset = 0;
reg data_in = 0;

wire data_out;

test1 I0(data_in, data_out, reset, clk);

// Set clock.
always #5 clk = ~clk;
always #10 $display($time, " reset: %b, data_in: %b, data_out: %b, state: %b",
                    reset, data_in, data_out, I0.state);

// Test data.
initial begin
    #2 reset = 1;
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



module test1 (data_in, data_out, reset, clk);

input data_in;
output data_out;
input reset;
input clk;

reg data_out;
//reg[2:0] state;
reg[2:0] state;
//parameter A=2'd0, B=2'd1, C=2'd2, D=2'd3, E=2'd4;
parameter A=3'd1, B=3'd2, C=3'd3, D=3'd4, E=3'd5;

always @(posedge clk or negedge reset)
	if(reset==0) begin state=A; data_out=0; end
	else begin
	case(state)
		A: begin data_out = 0; if (data_in==0) state=B;	else state=C; end 
		B: begin data_out = 0; if (data_in==0) state=B;	else state=D; end 
		C: begin data_out = 0; if (data_in==0) state=E;	else state=C; end 
		D: begin data_out = 1; if (data_in==0) state=E;	else state=C; end 
		E: begin data_out = 1; if (data_in==0) state=B;	else state=D; end
	       default: state=A;
       endcase
end
endmodule
		



