module histogram_tb();

reg clk = 0, reset_n = 0, score_en = 0, get_result = 0;
reg [7:0] score;

wire rdy;
wire [7:0] data;
wire [7:0] num;

histogram histogram(clk, reset_n, score_en, score, get_result, rdy, data, num);

always begin
	#5 clk = ~clk; 
end

wire [7:0] low, high;

assign low = (num - 1) * 10;
assign high = (num == 11) ? 100 : low + 9;

initial begin
	#2	reset_n = 1;

	#10 	score_en = 1; 
		score = 8'd43;
	#10	score = 8'd65;
	#10	score = 8'd51;
	#10	score = 8'd27;
	#10	score = 8'd79;
	#10	score = 8'd11;
	#10	score = 8'd56;
	#10	score = 8'd61;
	#10	score = 8'd82;
	#10	score = 8'd09;
	#10	score = 8'd25;
	#10	score = 8'd36;
	#10	score = 8'd07;
	#10	score = 8'd49;
	#10	score = 8'd55;
	#10	score = 8'd63;
	#10	score = 8'd74;
	#10	score = 8'd81;
	#10	score = 8'd49;
	#10	score = 8'd37;
	#10	score = 8'd40;
	#10	score = 8'd49;
	#10	score = 8'd16;
	#10	score = 8'd75;
	#10	score = 8'd87;
	#10	score = 8'd91;
	#10	score = 8'd33;
	#10	score = 8'd24;
	#10	score = 8'd58;
	#10	score = 8'd78;
	#10	score = 8'd65;
	#10	score = 8'd56;
	#10	score = 8'd76;
	#10	score = 8'd67;
	#10	score = 8'd45;
	#10	score = 8'd54;
	#10	score = 8'd36;
	#10	score = 8'd63;
	#10	score = 8'd12;
	#10	score = 8'd21;
	#10	score = 8'd73;
	#10	score = 8'd49;
	#10	score = 8'd51;
	#10	score = 8'd19;
	#10	score = 8'd39;
	#10	score = 8'd49;
	#10	score = 8'd68;
	#10	score = 8'd93;
	#10	score = 8'd85;
	#10	score = 8'd59;
	
	#10	score_en = 0;
		$display("GROUP\t  RANGE\t     STUDENT#");

	#15	get_result = 1;
	#10	$monitor("%2d\t%3d to %3d\t%d", num, low, high, data);

	#100	get_result = 0;
	#10	$finish;
end
endmodule
