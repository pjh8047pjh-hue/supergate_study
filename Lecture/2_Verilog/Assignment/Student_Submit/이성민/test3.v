module street_light_controller_tb;

wire light;
reg [3:0] all_switches = 0;
wire [2:0] switches = all_switches[2:0];
wire master_switch = all_switches[3];

street_light I0(.sw(switches[2:0]), .master(master_switch), .out(light));

initial begin
    $monitor("master_switch: %b, switches: %b, light: %b",
             master_switch, switches, light);

    repeat (15) #5 all_switches = all_switches + 1;

    $finish;
end

endmodule

module street_light(sw,master,out);

input [2:0]sw;
wire [3:0] na;
input master;
output out;

assign na[0] = ~(sw[0]&~sw[2]&~sw[1]&master);
assign na[1] = ~(~sw[0]&sw[1]&~sw[2]&master);
assign na[2] = ~(~sw[0]&sw[1]&sw[2]&master);
assign na[3] = ~(sw[0]&sw[1]&sw[2]&master);
assign out = ~(na[0]&na[1]&na[2]&na[3]);

endmodule
