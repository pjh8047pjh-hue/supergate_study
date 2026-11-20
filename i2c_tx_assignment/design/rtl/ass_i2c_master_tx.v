module ass_i2c_master_tx (
    input  wire         clk,
    input  wire         reset_n,
    input  wire         start,
    input  wire         mode,
    input  wire [  6:0] length,
    input  wire [  7:0] freq_i2c,
    input  wire [  7:0] start_addr,
    input  wire [  6:0] dev_adr,
    input  wire [639:0] data,
    input  wire         sda_in,

    output wire         sda_oe,
    output wire         scl_update,
    output wire         done,
    output wire [  7:0] wdata,
    output wire [  6:0] addr,
    output wire         we
);

//=============================================================================
wire        shift;
wire        sampling;
wire [ 6:0] cnt_byte;

ass_i2c_master_counter u_counter (
    .clk        (clk),
    .reset_n    (reset_n),
    .start      (start),
    .done       (done),
    .freq_i2c   (freq_i2c),

    .shift      (shift),
    .sampling   (sampling),
    .cnt_byte   (cnt_byte),
    .scl_update (scl_update)
);
//=============================================================================
wire        rw_bit;
wire [ 1:0] sel_pkg;    // TODO: no driver yet (tx_ctrl should generate)
wire [ 7:0] data_out;

ass_i2c_master_sel_pkg u_sel_pkg (
    .clk       (clk),
    .reset_n   (reset_n),
    .data      (data),
    .rw_bit    (rw_bit),
    .cnt_byte  ({1'b0, cnt_byte}),
    .dev_adr   (dev_adr),
    .start_addr(start_addr),
    .sel_pkg   (sel_pkg),

    .data_out  (data_out)
);
//=============================================================================
wire        sel_sda;
wire        load;       // TODO: no driver yet (tx_ctrl should generate)
wire        sda_out_fsm;
wire        sda_out;

ass_i2c_master_serializer_p2s u_p2s (
    .clk        (clk),
    .reset_n    (reset_n),
    .data_in    (data_out),
    .sel_sda    (sel_sda),
    .load       (load),
    .shift      (shift),
    .sda_out_fsm(sda_out_fsm),

    .sda_out    (sda_out)
);

assign sda_oe = ~sda_out;   // top: sda = sda_oe ? 1'b0 : 1'bz
//=============================================================================
ass_i2c_master_serializer_s2p u_s2p (
    .clk     (clk),
    .reset_n (reset_n),
    .sda_in  (sda_in),
    .sampling(sampling),

    .wdata   (wdata)
);
//=============================================================================
wire [ 3:0] cnt_bit;    // TODO: no driver yet (counter has no cnt_bit output port)

ass_i2c_master_tx_ctrl u_tx_ctrl (
    .clk        (clk),
    .reset_n    (reset_n),
    .start      (start),
    .mode       (mode),
    .length     (length),
    .start_addr (start_addr),
    .sampling   (sampling),
    .shift      (shift),
    .scl_update (scl_update),
    .cnt_byte   (cnt_byte),
    .cnt_bit    (cnt_bit),

    .rw_bit     (rw_bit),
    .we         (we),
    .done       (done),
    .addr       (addr),
    .sel_sda    (sel_sda),
    .sda_out_fsm(sda_out_fsm)
);
//=============================================================================

endmodule
