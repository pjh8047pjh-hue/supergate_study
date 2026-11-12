`timescale 1ns / 1ps

module ass_i2c_slave_rx #(
    parameter [6:0] device_address = 7'h45
) (
    input clk,
    input rstb,
    input scl,
    input sda,
    input [7:0] rdata,

    output wire sda_oe,
    output wire we,
    output wire read_en,
    output reg [7:0] addr,
    output reg [7:0] wdata
);

wire sda_d2;
wire init_addr;
wire rx_en;
wire addr_inc;

ass_i2c_slave_rx_ctrl #(.device_address(device_address)) u_ctrl (
    .clk        (clk),
    .rstb       (rstb),
    .scl        (scl),
    .sda        (sda),
    .wdata      (wdata),
    .rdata      (rdata),
    .sda_d2     (sda_d2),
    .sda_oe     (sda_oe),
    .init_addr  (init_addr),
    .rx_en      (rx_en),
    .addr_inc   (addr_inc),
    .read_en    (read_en),
    .we         (we)
);

always @(posedge clk or negedge rstb) begin
    if (!rstb)
        addr <= 8'b0;
    else if (rx_en && init_addr)
        addr <= {addr[6:0], sda_d2};
    else if (addr_inc)
        addr <= addr + 1'b1;
end

always @(posedge clk or negedge rstb) begin
    if (!rstb)
        wdata <= 8'b0;
    else if (rx_en && !init_addr)
        wdata <= {wdata[6:0], sda_d2};
end

endmodule
