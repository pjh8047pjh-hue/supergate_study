module two_level_1bit_synchronizer (
    input  clk,
    input  data_in,

    output data_out
);

reg [1:0] two_bit_sync;

always @(posedge clk) begin
    two_bit_sync <= {two_bit_sync[0], data_in};
end

assign data_out = two_bit_sync[1];

endmodule //: 2_level_synchronizer