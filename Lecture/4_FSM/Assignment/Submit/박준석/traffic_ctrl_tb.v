module traffic_ctrl_tb();

reg clk, rst, X;
wire [1:0] hw, fw;

traffic_ctrl ctrl(.hw(hw), .fw(fw), .X(X), .clk(clk), .rst(rst));

always begin
	#5 clk = ~clk;
	if(clk) $display("time : %3t, X = %b, state = %d, hw = %d, fw = %d", $time, X, ctrl.current_state, hw, fw);
end

initial begin
	clk = 0; rst = 0; X = 0;
#5	rst = 1;
#40	X = 1;
#40	X = 0;
#40	X = 1;
#40	$finish;
end
endmodule
