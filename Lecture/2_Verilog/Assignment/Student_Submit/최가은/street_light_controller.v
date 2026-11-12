module street_light_controller(
    output light,
    input [2:0] switches,
    input master_switch
    );
    wire a, b, c, d;
    
    nand (a, switches[0],~switches[1],~switches[2],master_switch);
    nand (b, switches[1],~switches[0],~switches[2],master_switch);    
    nand (c, switches[2],~switches[1],~switches[0],master_switch);   
    nand (d, switches[0],switches[1],switches[2],master_switch);
    nand (light, a,b,c,d);
        
endmodule
