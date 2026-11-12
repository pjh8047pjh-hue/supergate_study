`timescale 1ns / 1ps

module ass_i2c_slave #(
    parameter [6:0] device_address = 7'h45
) (
    input clk,
    input rstb,
    input scl,
    inout sda
);

wire sda_oe;
wire we;
wire [7:0] addr;
wire [7:0] wdata;
wire [7:0] rdata;

assign sda = sda_oe ? 1'b0 : 1'bz;

ass_i2c_slave_rx #(.device_address(device_address)) u_rx (
    .clk    (clk),
    .rstb   (rstb),
    .scl    (scl),
    .sda    (sda),
    .rdata  (rdata),
    .sda_oe (sda_oe),
    .we     (we),
    .addr   (addr),
    .wdata  (wdata)
);

ass_i2c_slave_rf u_rf (
    .clk   (clk),
    .addr  (addr[6:0]),
    .wdata (wdata),
    .we    (we),
    .rdata (rdata)
);

endmodule
