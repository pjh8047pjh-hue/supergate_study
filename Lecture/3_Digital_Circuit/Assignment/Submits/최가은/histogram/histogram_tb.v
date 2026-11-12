/**int score[50] = {
43, 65, 51, 27, 79, 11, 56, 61, 82,  9,
25, 36,  7, 49, 55, 63, 74, 81, 49, 37,
40, 49, 16, 75, 87, 91, 33, 24, 58, 78,
65, 56, 76, 67, 45, 54, 36, 63, 12, 21,
73, 49, 51, 19, 39, 49, 68, 93, 85, 59
};**/

module histogram_tb();
reg clk=0;
reg reset_n;
reg score_ena;
reg get_result;
reg [7:0] score;
wire rdy;
wire [7:0] data;

histogram u_histogram (
					   .clk       (clk       ),
					   .data      (data      ),
					   .get_result(get_result),
					   .rdy       (rdy       ),
					   .reset_n   (reset_n   ),
					   .score     (score     ),
					   .score_ena (score_ena )
	);
	always #5 clk = ~clk;
	
	initial begin
		/**$monitor("GROUP: %d, RANGE: %d to %d, STUDENT: %d",
             clk, quick_clk, data);**/
		
		reset_n=0; score_ena=0; score=0; get_result=0;
		#5 reset_n=1;
		#20 score_ena=1; score=43; 
		#10 score=65; 
		#10 score=51; 
		#10 score=27; 
		#10 score=79; 
		#10 score=11; 
		#10 score=56; 
		#10 score=61; 
		#10 score=82; 
		#10 score=9;
		#10 score=25; 
		#10 score=36;  
		#10 score=7; 
		#10 score=49; 
		#10 score=55; 
		#10 score=63; 
		#10 score=74; 
		#10 score=81; 
		#10 score=49; 
		#10 score=37;
		#10 score=40; 
		#10 score=49; 
		#10 score=16; 
		#10 score=75; 
		#10 score=87; 
		#10 score=91; 
		#10 score=33; 
		#10 score=24; 
		#10 score=58; 
		#10 score=78;
		#10 score=65; 
		#10 score=56; 
		#10 score=76; 
		#10 score=67; 
		#10 score=45; 
		#10 score=54; 
		#10 score=36; 
		#10 score=63; 
		#10 score=12; 
		#10 score=21;
		#10 score=73; 
		#10 score=49; 
		#10 score=51; 
		#10 score=19; 
		#10 score=39; 
		#10 score=49; 
		#10 score=68; 
		#10 score=93; 
		#10 score=85; 
		#10 score=59;
		#10 score_ena=0; score=0; 
		#50 get_result=1;
		#110 get_result=0;
	
	end
	
endmodule
