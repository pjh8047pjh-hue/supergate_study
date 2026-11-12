module tb_voter;

reg [2:0] agree;
wire indicator;

voter dut(
  .indicator(indicator),
  .agree(agree)
);

initial begin
    #0 agree = 3'b0;
    $monitor("agree: %b, indicator: %b", agree, indicator);

    #5 agree = 3'b001;
    #5 agree = 3'b010;
    #5 agree = 3'b011;
    #5 agree = 3'b100;
    #5 agree = 3'b101;
    #5 agree = 3'b110;
    #5 agree = 3'b111;

    //$finish;
end

endmodule
