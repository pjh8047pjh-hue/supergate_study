module ass_i2c_master_scl_gen (
    input  wire clk,
    input  wire reset_n,
    input  wire scl_update,

    output reg  scl_oe
);
    
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        scl_oe <= 1'b1;
    end
    else if (scl_update) begin
        scl_oe <= !scl_oe;
    end
end

endmodule