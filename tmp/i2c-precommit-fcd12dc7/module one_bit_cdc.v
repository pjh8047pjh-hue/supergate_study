module one_bit_cdc_cntl (
    input  clk,
    input  rstb,
    input  cntl_in,

    output reg  ack_out,
    output wire cntl_out
);
//=============================================================================
reg [1:0] two_bit_sync;

always @(posedge clk or negedge rstb) begin
    if(~rstb) begin
        two_bit_sync <= 2'b0;
    end else begin
        two_bit_sync <= {two_bit_sync[0], cntl_in}; 
    end
end
//=============================================================================

//=============================================================================
reg [1:0] rise_detect;

always @(posedge clk or negedge rst_n) begin
    if(~rstb) begin
        rise_detect <= 2'b0;
    end else begin
        rise_detect <= {rise_detect[0], two_bit_sync[1]};
    end
end
//=============================================================================

//=============================================================================
always @(posedge clk or negedge rstb) begin
    if(~rstb) begin
        ack_out <= 1'b0;
    end else if(two_bit_sync[1]) begin
        ack_out <= 1'b1;
    end else if begin
        ack_out <= 1'b0;
    end
end

assign cntl_out = rise_detect[0] && ~rise_detect[1];
//=============================================================================

endmodule //: one_bit_cdc