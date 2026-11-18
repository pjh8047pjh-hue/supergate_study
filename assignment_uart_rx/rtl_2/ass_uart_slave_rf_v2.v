module ass_uart_slave_rf_v2 (
    input clk,
    input [6:0] addr,
    input [7:0] wdata,
    input we,

    output reg  [7:0] rdata
);

reg [7:0] mem [0:127];

always @(posedge clk) begin
    if (we) begin
        mem[addr] <= wdata;
    end

    rdata <= mem[addr];
end

endmodule