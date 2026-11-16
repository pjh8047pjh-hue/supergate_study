module ass_uart_serdes_shift_reg_p2s (
    input  wire       clk,
    input  wire       rstb,
    input  wire       start,
    input  wire [7:0] parallel_in,
    input  wire [3:0] cnt_bit,
    input  wire       data_en,
    input  wire       tx_update,

    output reg        serial_out
);
//=============================================================================
reg [7:0] output_reg;

always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        output_reg <= 8'b0;
    end
    else if (start) begin
        output_reg <= parallel_in;
    end
end
//=============================================================================
always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        serial_out <= 1'b1;
    end
    else if (start) begin
        serial_out <= 1'b0;
    end
    else if (tx_update) begin
        if ((cnt_bit >= 4'd1) && (cnt_bit <= 4'd8)) begin
            serial_out <= output_reg[cnt_bit - 1'b1];
        end
        if (cnt_bit == 4'd9) begin
            serial_out <= 1'b1;
        end
    end
end
//=============================================================================
endmodule