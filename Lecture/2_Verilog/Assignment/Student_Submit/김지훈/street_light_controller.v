module street_light_controller(light,switches,master_switch);


output light;
input [2:0] switches; 
input master_switch;


wire [3:0] w;


nand U0 (w[0], switches[0], ~switches[1], ~switches[2], master_switch);
nand U1 (w[1], ~switches[0] , switches[1] , ~switches[2] , master_switch); 
nand U2 (w[2], ~switches[0] , ~switches[1] , switches[2] , master_switch);
nand U3 (w[3], switches[0] , switches[1] , switches[2] , master_switch);
nand U4 ( light, w[0] , w[1] , w[2] , w[3]);

endmodule
