module ass_i2c_master_serializer_s2p (
    input  wire       clk,        
    input  wire       reset_n,
    input  wire       sda_in,
    input  wire       sampling,

    output reg  [7:0] wdata
);

//=============================================================================
// 2 level synchronizer
reg [1:0] sda_sync;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        sda_sync <= 2'b0;
    end
    else if (sampling) begin
        sda_sync <= {sda_sync[0], sda_in};
    end
end
//=============================================================================
// serial to parallel shift reg
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        wdata <= 8'b0;
    end
    else if (sampling) begin
        wdata <= {wdata[6:0], sda_sync};
    end
end
//=============================================================================
endmodule