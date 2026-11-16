module ass_uart_slave_pkg_dec (
    input  wire       clk,
    input  wire       rstb,
    input  wire       rx_empty,
    input  wire       tx_full,
    input  wire [6:0] dev_addr,
    input  wire [7:0] rx_rdata,
    input  wire [7:0] rdata,

    output wire       we,
    output wire [7:0] wdata,
    output wire [6:0] addr,
    output wire       rx_ren,
    output wire       tx_wen,
    output wire [7:0] tx_wdata
);
//=============================================================================
wire       addr_match;
wire       addr_inc;
wire       mode;
wire       rx_ren_d;
wire       init_cmd;
wire       init_addr;
wire       init_length;
wire [7:0] length;

assign addr_match = ({1'b0, dev_addr} == rx_rdata);

ass_uart_slave_pkg_dec_fsm u_pkg_dec_fsm (
    .clk        (clk),
    .rstb       (rstb),
    .rx_empty   (rx_empty),
    .tx_full    (tx_full),
    .mode       (mode),
    .addr_match (addr_match),
    .length     (length),

    .we         (we),
    .addr_inc   (addr_inc),
    .rx_ren     (rx_ren),
    .rx_ren_d   (rx_ren_d),
    .tx_wen     (tx_wen),
    .init_cmd   (init_cmd),
    .init_addr  (init_addr),
    .init_length(init_length)
);
//=============================================================================
ass_uart_slave_pkg_dec_reg u_pkg_dec_reg (
    .clk        (clk),
    .rstb       (rstb),
    .rx_rdata   (rx_rdata),
    .addr_inc   (addr_inc),
    .rx_ren_d   (rx_ren_d),
    .rdata      (rdata),
    .we         (we),
    .init_cmd   (init_cmd),
    .init_addr  (init_addr),
    .init_length(init_length),

    .mode       (mode),
    .addr       (addr),
    .length     (length),
    .wdata      (wdata),
    .tx_wdata   (tx_wdata)
);
//=============================================================================
endmodule
