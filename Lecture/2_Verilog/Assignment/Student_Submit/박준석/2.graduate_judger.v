module graduate_judger(eligible_to_graduate, pass);

input [3:0] pass;
//output reg eligible_to_graduate;
output wire eligible_to_graduate;

//wire [1:0] net;
/*
assign net[0] = ~(pass[0] & pass[1] & pass[3]);
assign net[1] = ~(pass[2] & pass[3]);

always @(*) begin
	eligible_to_graduate = ~(net[0] & net[1]);
end
*/

assign eligible_to_graduate = 	~(~(pass[0] & pass[1] & pass[3]) & ~(pass[2] & pass[3]));

endmodule
