module ass_uart_slave_pkg_dec_fsm (
    input  wire clk,
    input  wire rstb,
    input  wire rx_empty,
    input  wire tx_full,
    input  wire mode,
    input  wire addr_match,
    input  wire [7:0] length,

    output wire we,
    output wire addr_inc,
    output wire rx_ren,
    output reg  rx_ren_d,
    output wire tx_wen,
    output wire init_cmd,
    output wire init_addr,
    output wire init_length
);

localparam IDLE    = 3'b000;
localparam START   = 3'b001;
localparam CMD     = 3'b010;
localparam CHECK   = 3'b011;
localparam ADDR    = 3'b100;
localparam LENGHTH = 3'b101;
localparam READ    = 3'b110;
localparam WRITE   = 3'b111;
//=============================================================================
reg [2:0] nstate;
reg [2:0] cstate;
reg [7:0] cnt_rx;
reg [7:0] cnt_tx;
reg [1:0] rx_write_d;

always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        cnt_rx <= 8'b0;
    end
    else if (cstate != WRITE) begin
        cnt_rx <= 8'b0;
    end
    else if (rx_ren) begin
        cnt_rx <= cnt_rx + 1'b1;
    end
end

always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        cnt_tx <= 8'b0;
    end
    else if (cstate != READ) begin
        cnt_tx <= 8'b0;
    end
    else if (tx_wen) begin
        cnt_tx <= cnt_tx + 1'b1;
    end
end
//=============================================================================
wire      tx_wen_pre;
reg [1:0] tx_wen_d;

always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        cstate <= IDLE;
    end
    else begin
        cstate <= nstate;
    end
end
//=============================================================================
always @(*) begin
    nstate = cstate;

    case (cstate)
        IDLE    : nstate = rx_ren ? START : IDLE;
        START   : nstate = rx_ren ? CMD   : START;
        CMD     : nstate = rx_ren ? CHECK : CMD;
        CHECK   : nstate = addr_match ? ADDR : IDLE;
        ADDR    : nstate = rx_ren ? LENGHTH : ADDR;
        LENGHTH : nstate = rx_ren ? (mode ? WRITE : READ) : LENGHTH;
        READ    : nstate = (cnt_tx == length) ? IDLE : READ;
        WRITE   : nstate = ((cnt_rx == length) && !(|rx_write_d)) ? IDLE : WRITE;
    endcase
end
//=============================================================================
always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        rx_ren_d <= 1'b0;
    end
    else if (rx_ren) begin
        rx_ren_d <= rx_ren && ~rx_empty;
    end 
    else begin
        rx_ren_d <= 1'b0;
    end
end

always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        rx_write_d <= 2'b00;
    end
    else begin
        rx_write_d <= {rx_write_d[0], rx_ren && (cstate == WRITE)};
    end
end

always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        tx_wen_d <= 2'b00;
    end
    else begin
        tx_wen_d <= {tx_wen_d[0], tx_wen_pre};
    end
end

assign rx_ren = ~rx_empty && ((cstate == IDLE)
                          || (cstate == START)
                          || (cstate == CMD)
                          || (cstate == ADDR)
                          || (cstate == LENGHTH)
                          || ((cstate == WRITE) && (cnt_rx < length)));

assign we          =  rx_write_d[1];
// Allow one RF read in flight so FIFO space and read-data latency stay aligned.
assign tx_wen_pre  =  ~tx_full && (cstate == READ)
                   && (cnt_tx < length) && !(|tx_wen_d);
assign tx_wen      =  tx_wen_d[1] && !tx_full;
assign addr_inc    =  we || tx_wen_pre;
assign init_cmd    = (cstate == CMD);
assign init_addr   = (cstate == ADDR)    && rx_ren;
assign init_length = (cstate == LENGHTH) && rx_ren;
//=============================================================================

endmodule
