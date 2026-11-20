
module ass_i2c_master (
  input         clk    ,
  input         rstb   ,
  input [  6:0] dev_adr,  // I2C device address
  input         start  ,  // run master
  input [639:0] data   ,  // MSB first out tx_data
  input [  7:0] ctrl0  ,  // CTRL0 Register
  input [  7:0] ctrl1  ,  // CTRL1 Register
  input [  7:0] ctrl2  ,  // CTRL2 Register
  output        done   ,  // Indication for finishing transfer
  output        scl    ,  // I2C SCL to slave
  inout         sda       // I2C data
);

// Processing bi-directional port
wire sda_oe;
wire scl_oe;
wire sda_in = sda;

assign sda = (sda_oe)? 1'b0: 1'bz;
assign scl = (scl_oe)? 1'b0: 1'bz;

// ---------------------------------------------------------------
// Control Register Description
// ---------------------------------------------------------------
// ctrl0  : [7  ] write (0) or read (1)
//          [6:0] byte length of data (1 ~ 80)
// ctrl1  : [7:0] I2C Speed/Clock Freq
// ctrl2  : [7:0] start address
// start  : run i2c_master_top

wire scl_update;

ass_i2c_master_scl_gen u_scl_gen (
    .clk       (clk),
    .reset_n   (rstb),
    .scl_update(scl_update),

    .scl_oe    (scl_oe)
);

wire sampling;
wire shift;
wire rw_bit;
wire we;    
wire [6:0] addr;
wire sda_out_fsm;

ass_i2c_master_tx_ctrl u_tx_ctrl(
    .clk        (clk),
    .reset_n    (rstb),
    .start      (start),
    .mode       (ctrl0[7]),
    .length     (ctrl0[6:0]),
    .start_addr (ctrl2),
    .sampling   (sampling),
    .shift      (shift),

    .rw_bit     (rw_bit),
    .we         (we),
    .done       (done),
    .addr       (addr),
    .sda_out_fsm(sda_out_fsm)
);

endmodule
