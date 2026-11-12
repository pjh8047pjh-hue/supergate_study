module tb_thermometer_to_bcd;

wire [7:0] bcd;
reg [15:0] thermometer;

thermometer_to_bcd dut(
  .bcd (bcd),
  .thermometer(thermometer)
);

initial begin
    thermometer = 0;
    $monitor("thermometer: %b, bcd: %b, dec: %d%d",
             thermometer, bcd, bcd[7:4], bcd[3:0]);

    repeat (16) #5 thermometer = {thermometer[14:0], 1'b1};

    $finish;
end

endmodule
