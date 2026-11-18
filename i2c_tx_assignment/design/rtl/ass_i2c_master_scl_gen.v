module ass_i2c_master_scl_gen (
    input  wire clk,
    input  wire reset_n,
    input  wire scl_high,
    input  wire scl_low,

    output reg  scl_oe
);
    
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        scl_oe <= 1'b0;
    end
    else if (scl_high) begin
        scl_oe <= 1'b0;
    end 
    else if (scl_low) begin
        scl_oe <= 1'b1;
    end
end

endmodule