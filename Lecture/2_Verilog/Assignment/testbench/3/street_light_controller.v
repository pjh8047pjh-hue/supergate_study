module street_light_controller(
output light,
input [2:0] switches,
input master_switch
);

// Code 2: easy interpretation
wire n1 = ~(master_switch & ( switches[0] & ~switches[1] & ~switches[2]));
wire n2 = ~(master_switch & (~switches[0] &  switches[1] & ~switches[2]));
wire n3 = ~(master_switch & (~switches[0] & ~switches[1] &  switches[2]));
wire n4 = ~(master_switch & ( switches[0] &  switches[1] &  switches[2]));
assign light = ~(n1 & n2 & n3 & n4);

// Code 2: easy interpretation
//wire n1 = master_switch & ( switches[0] & ~switches[1] & ~switches[2]);
//wire n2 = master_switch & (~switches[0] &  switches[1] & ~switches[2]);
//wire n3 = master_switch & (~switches[0] & ~switches[1] &  switches[2]);
//wire n4 = master_switch & ( switches[0] &  switches[1] &  switches[2]);
//assign light = n1 | n2 | n3 | n4;

// Code 2: Optmized
//assign light = master_switch & ^switches;

endmodule
