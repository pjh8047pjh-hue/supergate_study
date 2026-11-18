module ass_i2c_master_rf (
    input  wire       clk,    
    input  wire       we,
    input  wire [6:0] addr,
    input  wire [7:0] wdata    
);

reg [7:0] rf [0:127]

always @(posedge clk) begin
    if(we) begin
        rf[addr] <= wdata;
    end
end

endmodule