
module voter(indicator, agree);

output indicator;
input [2:0] agree ;

wire indicator;
assign indicator = (agree[0]&agree[1])|
 		   (agree[0]&agree[2])| 	
		   (agree[1]&agree[2]);


 endmodule    




module voter_tb;

reg [2:0] agree = 0;
wire indicator;

voter voter1(indicator, agree);

initial begin
    $monitor("agree: %b, indicator: %b", agree, indicator);

    #5 agree = 3'b001;
    #5 agree = 3'b010;
    #5 agree = 3'b011;
    #5 agree = 3'b100;
    #5 agree = 3'b101;
    #5 agree = 3'b110;
    #5 agree = 3'b111;

    $finish;
end

endmodule
