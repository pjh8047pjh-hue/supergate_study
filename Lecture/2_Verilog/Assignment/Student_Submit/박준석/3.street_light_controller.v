module street_light_controller(light, switches, master_switch);

input master_switch;
input [2:0] switches;
output wire light;
//output reg light;

wire [3:0] net;

assign net[0] = ~( switches[0] & ~switches[1] & ~switches[2] & master_switch);
assign net[1] = ~(~switches[0] &  switches[1] & ~switches[2] & master_switch);
assign net[2] = ~(~switches[0] & ~switches[1] &  switches[2] & master_switch);
assign net[3] = ~( switches[0] &  switches[1] &  switches[2] & master_switch);

assign light = ~(net[0] & net[1] & net[2] & net[3]);

/*
always @(*) begin
	light = ~(net[0] & net[1] & net[2] & net[3]);
end
*/
endmodule
