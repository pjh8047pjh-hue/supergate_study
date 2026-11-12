module cdc_handshake_sync (
    input  clk,
    input  rstb,
    input  req_in,

    output reg  ack_out,
    output wire req_pulse
);
//=============================================================================
// 2 level sychronizer
reg [1:0] req_sync_ff;

always @(posedge clk or negedge rstb) begin
    if(~rstb) begin
        req_sync_ff <= 2'b0;
    end else begin
        req_sync_ff <= {req_sync_ff[0], req_in}; 
    end
end
//=============================================================================

//=============================================================================
// rise edge detecter
reg [1:0] req_edge_ff;

always @(posedge clk or negedge rstb) begin
    if(~rstb) begin
        req_edge_ff <= 2'b0;
    end else begin
        req_edge_ff <= {req_edge_ff[0], req_sync_ff[1]};
    end
end
//=============================================================================

//=============================================================================
always @(posedge clk or negedge rstb) begin
    if(~rstb) begin
        ack_out <= 1'b0;
    end else if(req_sync_ff[1]) begin
        ack_out <= 1'b1;
    end else begin
        ack_out <= 1'b0;
    end
end

assign req_pulse = req_edge_ff[0] && ~req_edge_ff[1];
//=============================================================================

endmodule //: cdc_handshake_sync
