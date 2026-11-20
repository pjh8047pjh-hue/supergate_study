module ass_i2c_master_serializer_p2s (
    input  wire       clk,
    input  wire       reset_n,
    input  wire [7:0] data_in,
    input  wire       sel_sda,
    input  wire       load,
    input  wire       shift,
    input  wire       sda_out_fsm,

    output wire       sda_out
);
reg  [7:0] p2s;

always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        p2s <= 8'b0;
    end
    else if (load)
        p2s <= data_in;
    else if (shift) begin
        p2s <= {p2s[6:0], 1'b0};
    end
end

assign sda_out = sel_sda ? p2s[7] : sda_out_fsm;

endmodule
