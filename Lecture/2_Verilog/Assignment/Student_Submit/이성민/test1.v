`timescale 100ps / 100ps

module voter_tb;

reg [2:0] agree;
wire indicator;

indicator I0 (.A(agree[0]), .B(agree[1]), .C(agree[2]), .out(indicator));

initial begin
//    $monitor("agree: %b, indicator: %b", agree, indicator);
	$monitor(agree[0], agree[1], agree[2], indicator);

    #5; agree = 3'b001;
    #5; agree = 3'b010;
    #5; agree = 3'b011;
    #5; agree = 3'b100;
    #5; agree = 3'b101;
    #5; agree = 3'b110;
    #5; agree = 3'b111;

    $finish;
end

endmodule


module indicator(A,B,C,out);
input A;
input B;
input C;
output out;

wire an[0:2];

assign an[0] = A&B;
assign an[1] = A&C;
assign an[2] = B&C;
assign out = an[0]|an[1]|an[2];

endmodule

