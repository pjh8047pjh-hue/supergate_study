module graduate_judger_tb;

wire eligible_to_graduate;
reg [3:0] pass;

graduate_judger I0(.pass(pass[3:0]), .out(eligible_to_graduate));

initial begin
    $monitor("DCBA: %b, eligible_to_graduate: %b", pass, eligible_to_graduate);

    pass = 4'b0000;
    repeat (15) #5 pass = pass + 1;

    $finish;
end

endmodule

module graduate_judger(pass,out);
input [3:0]pass;
output out;

wire na[0:1];

assign na[0] = ~(pass[0]&pass[1]&pass[3]);
assign na[1] = ~(pass[2]&pass[3]);
assign out = ~(na[0]&na[1]);

endmodule
