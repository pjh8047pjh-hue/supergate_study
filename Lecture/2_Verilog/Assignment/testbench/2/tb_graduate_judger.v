module tb_graduate_judger;

wire eligible_to_graduate;
reg [3:0] pass;

graduate_judger dut (
  .eligible_to_graduate(eligible_to_graduate),
  .pass(pass)
);

initial begin
    pass = 4'b0;

    $monitor("DCBA: %b, eligible_to_graduate: %b", pass, eligible_to_graduate);

    repeat (15) #5 pass = pass + 1;

    $finish;
end

endmodule
