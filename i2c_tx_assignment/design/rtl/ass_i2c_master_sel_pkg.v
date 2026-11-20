module ass_i2c_master_sel_pkg (
    input  wire         clk,
    input  wire         reset_n,
    input  wire [639:0] data,
    input  wire         rw_bit,
    input  wire [  6:0] cnt_byte,
    input  wire [  6:0] dev_adr,
    input  wire [  7:0] start_addr,
    input  wire [  1:0] sel_pkg,

    output wire [  7:0] data_out
);
    
//=============================================================================
// data MUX
wire [7:0] sel_data;

assign sel_data = data[639 - cnt_byte -: 8];
//=============================================================================
// dev_adr + rw
wire [7:0] first_pkg;

assign first_pkg = {dev_adr, rw_bit};
//=============================================================================
// sel_pkg logic

assign data_out = (sel_pkg == 2'd0) ? start_addr :
                  (sel_pkg == 2'd1) ? first_pkg  :
                  (sel_pkg == 2'd2) ? sel_data   : 8'd0;
//============================================================================= 

endmodule
