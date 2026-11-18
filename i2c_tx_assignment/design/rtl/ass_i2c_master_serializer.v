module ass_i2c_master_serializer (
    input  wire         clk,
    input  wire         reset_n,
    input  wire         start,
    input  wire         stop,
    input  wire         mode,
    input  wire [639:0] data,
    
    output wire         scl_oe,
    output wire         sda_oe,
    output reg  [  7:0] wdata
);



endmodule