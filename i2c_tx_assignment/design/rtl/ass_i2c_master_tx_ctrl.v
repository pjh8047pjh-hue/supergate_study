module ass_i2c_master_tx_ctrl (
    input  wire       clk
    input  wire       reset_n,
    input  wire       start,
    input  reg        mode,
    input  reg  [6:0] length,
    input  reg  [7:0] freq_i2c,
    input  reg  [7:0] start_addr,

    output wire       we,
    output wire       done,
    output wire       addr_inc,
    output wire [6:0] addr,
);



endmodule