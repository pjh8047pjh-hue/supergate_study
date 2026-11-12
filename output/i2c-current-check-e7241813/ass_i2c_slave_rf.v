`timescale 1ns / 1ps

module ass_i2c_slave_rf (
    input clk,
    input rstb,
    input read_en,
    input [6:0] addr,
    input [7:0] wdata,
    input we,

    output reg [7:0] rdata
);

reg [7:0] mem [0:127];

always @(posedge clk) begin
    if (we) begin
        mem[addr] <= wdata;
    end

end

always @(posedge clk or negedge rstb) begin
    if (!rstb)
        rdata <= 8'b0;
    else if (read_en)
        rdata <= mem[addr];
end

endmodule
