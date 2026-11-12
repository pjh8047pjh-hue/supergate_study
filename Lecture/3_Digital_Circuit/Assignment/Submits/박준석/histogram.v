module histogram(clk, reset_n, score_en, score, get_result, rdy, data, num);

input clk, reset_n, score_en, get_result;
input [7:0] score;

output reg rdy;
output reg [7:0] data;

reg [7:0] group [0:10];//int group[11] = {0};

wire [7:0] n;

assign n = (score < 10) ? 0:
	   (score < 20) ? 1:
	   (score < 30) ? 2:
	   (score < 40) ? 3:
	   (score < 50) ? 4:
	   (score < 60) ? 5:
	   (score < 70) ? 6:
	   (score < 80) ? 7:
	   (score < 90) ? 8:
	   (score < 100) ? 9:
	   (score == 100) ? 10 : 0; //int n = score[i]/10;

reg [3:0] i;

always @(posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		for (i = 0; i < 11; i = i + 1) begin
			group[i] <= 0;
		end 
	end //reset_n if
	else begin
		if (score_en) begin
			group[n] <= group[n] + 1; //group[n]++;
		end //score_en if
	end //reset_n else
end

output reg [7:0] num;

always @(posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		rdy <= 0;
		data <= 0;
		num <= 0;
	end
	else begin
		if (get_result) begin
			rdy <= 1;
			data <= group[num];
			num <= num + 1;
	       	end
		else begin
		       	rdy <= 0;
	       	end
	end
end

endmodule
