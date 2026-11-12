module fsm_tb();

reg clk, reset, in;
wire out;

fsm dut(.clk(clk), .reset(reset), .in(in), .out(out));

always begin
	#5 clk = ~clk;
	if(clk)	$display("time : %3t, current : %d, in : %b next : %d, out : %b, reset : %b",$time, dut.current_state, in, dut.next_state, out, reset);
end

initial begin
	reset = 0; in = 0; clk = 0;
#10	reset = 1;
#20	in = 1;
#20	in = 0;
#10	in = 1;
#10	in = 0;
#10	reset = 0;
#10	reset = 1; in = 1;
#20	$finish;

end
endmodule
