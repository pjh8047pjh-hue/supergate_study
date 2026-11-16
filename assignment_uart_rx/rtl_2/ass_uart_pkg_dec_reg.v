module ass_uart_slave_pkg_dec_reg (
    input  wire       clk,
    input  wire       rstb,
    input  wire [7:0] rx_rdata,
    input  wire       addr_inc,
    input  wire       rx_ren_d,
    input  wire [7:0] rdata,
    input  wire       we,
    input  wire       init_cmd,
    input  wire       init_addr,
    input  wire       init_length,

    output wire       mode,
    output reg  [6:0] addr,
    output reg  [7:0] length,
    output reg  [7:0] wdata,
    output reg  [7:0] tx_wdata
);

reg [1:0] cmd;
//=============================================================================    
always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        cmd <= 2'b0;
    end
    else if (init_cmd && rx_ren_d) begin
        cmd <= rx_rdata[5:4];
    end
end

assign mode = (cmd == 2'b01) ? 1'b0 : ((cmd == 2'b10) ? 1'b1 : 1'b0);
//=============================================================================
always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        addr <= 7'b0;
    end
    else if (init_addr) begin
        addr <= rx_rdata[6:0];
    end
    else if (addr_inc) begin
        addr <= addr + 7'b1;
    end
end
//=============================================================================
always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        length <= 8'b0;
    end
    else if (init_length) begin
        length <= rx_rdata;
    end
end
//=============================================================================
always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        wdata <= 8'b0;
    end
    else if (rx_ren_d) begin
        wdata <= rx_rdata;
    end
end
//=============================================================================
always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        tx_wdata <= 8'b0;
    end
    else begin
        tx_wdata <= rdata;
    end
end
//=============================================================================
endmodule
