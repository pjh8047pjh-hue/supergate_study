module ass_uart_serdes_shift_reg_s2p (
    input  wire       clk,
    input  wire       rstb,
    input  wire       sampling,
    input  wire       serial_in,
    input  wire       data_en,

    output wire [7:0] parallel_out
);

reg [7:0] shift_reg;

always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        shift_reg <= 8'b0;
    end
    else if (sampling) begin
        shift_reg <= {serial_in, shift_reg[7:1]};
    end 
end

assign parallel_out = data_en ? shift_reg : 8'b0;

endmodule