module tb_street_light_controller;

wire light;
reg [3:0] all_switches;
wire [2:0] switches = all_switches[2:0];
wire master_switch = all_switches[3];

street_light_controller dut(
  .light    (light   ),
  .switches (switches),
  .master_switch (master_switch)
);

initial begin
    all_switches = 4'b0;
    $monitor("master_switch: %b, switches: %b, light: %b",
             master_switch, switches, light);

    repeat (15) #5 all_switches = all_switches + 1;

    $finish;
end

endmodule
