`timescale 1ns / 1ps

module ass_i2c_slave #(
    parameter [6:0] device_address = 7'h45
) (
    input clk_1,
    input clk_2,
    input rstb,
    input scl,
    inout sda
);

wire sda_oe;

assign sda = sda_oe ? 1'b0 : 1'bz;


//=============================================================================
wire start_req;
wire stop_req;
wire req;

wire rx_wen;
wire rx_full;
wire [7:0] rx_wdata;

wire tx_ren;
wire tx_empty;  
wire [7:0] tx_rdata;

wire ack_out_req;

ass_i2c_slave_serdes #(.device_address(device_address)) u_serdes(
    .clk          (clk_1), 
    .rstb         (rstb),
    .scl          (scl),
    .sda          (sda),
    .rx_full      (rx_full),
    .tx_empty     (tx_empty),
    .tx_rdata_in  (tx_rdata),
    .ack_out_req  (ack_out_req),
    .ack_out_start(ack_out_start),
    .ack_out_stop (ack_out_stop),

    .start_req    (start_req),
    .stop_req     (stop_req),
    .req          (req),
    .rx_wen       (rx_wen),
    .rx_wdata     (rx_wdata),
    .tx_ren       (tx_ren),
    .sda_oe       (sda_oe)
);
//=============================================================================
wire rx_ren;
wire rx_empty;
wire [7:0] rx_rdata;

generic_fifo_dc u_rx_fifo(
    .rd_clk (clk_2), 
    .wr_clk (clk_1), 
    .rst    (rstb), 
    .clr    (), 
    .din    (rx_wdata),
    .we     (rx_wen), 
    .dout   (rx_rdata),
    .re     (rx_ren),
    .full   (rx_full), 
    .empty  (rx_empty), 
    .full_n (),
    .empty_n(), 
    .level  () 
);

wire tx_wen;
wire tx_full;
wire [7:0] tx_wdata;

generic_fifo_dc u_tx_fifo(
    .rd_clk (clk_1), 
    .wr_clk (clk_2), 
    .rst    (rstb),
    .clr    (), 
    .din    (tx_wdata),
    .we     (tx_wen), 
    .dout   (tx_rdata),
    .re     (tx_ren),
    .full   (tx_full), 
    .empty  (tx_empty), 
    .full_n (), 
    .empty_n(), 
    .level  () 
);

//=============================================================================
wire we;
wire [7:0] addr;
wire [7:0] rdata;
wire [7:0] wdata;

ass_i2c_slave_pkg_dec u_pkg_dec(
    .clk          (clk_2),  
    .rstb         (rstb),
    .start_req    (start_req),
    .stop_req     (stop_req),
    .req          (req),
    .rx_empty     (rx_empty),
    .rx_rdata     (rx_rdata),
    .tx_full      (tx_full),
    .rdata        (rdata),

    .ack_out_req  (ack_out_req),
    .ack_out_start(ack_out_start),
    .ack_out_stop (ack_out_stop),
    .rx_ren       (rx_ren),
    .tx_wen       (tx_wen),
    .tx_wdata     (tx_wdata),
    .we           (we),
    .addr         (addr),
    .wdata        (wdata)
);
//=============================================================================

//=============================================================================
ass_i2c_slave_rf_v2 u_rf(
    .clk   (clk_2),
    .addr  (addr[6:0]),
    .wdata (wdata),
    .we    (we),
    .rdata (rdata)
);
//=============================================================================
endmodule
