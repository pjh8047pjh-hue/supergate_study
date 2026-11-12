module graduate_judger_tb;

wire eligible_to_graduate;
reg [3:0] pass = 0;

graduate_judger judger(eligible_to_graduate, pass);

initial begin
    $monitor("DCBA: %b, eligible_to_graduate: %b", pass, eligible_to_graduate);

    repeat (15) #5 pass = pass + 1;

    $finish;
end

endmodule

module graduate_judger(output eligible_to_graduate, input [3:0] pass);

assign eligible_to_graduate = (pass[0]&&pass[1]&&pass[3])+(pass[2]&&pass[3]);

endmodule
