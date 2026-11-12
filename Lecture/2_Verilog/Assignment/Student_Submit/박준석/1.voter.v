module voter(indicator, agree);

input [2:0] agree;
//output reg indicator;
output wire indicator;

//wire [2:0] net;
//assign net[0] = agree[0] & agree[1];
//assign net[1] = agree[0] & agree[2];
//assign net[2] = agree[1] & agree[2];
/*
always @(*) begin
	indicator = net[0] | net[1] | net[2];
end
*/

assign indicator = (agree[0] & agree[1]) |
		   (agree[0] & agree[2]) |
		   (agree[1] & agree[2]);

endmodule

