module ass_i2c_master_counter (
    input  wire       clk,
    input  wire       reset_n,
    input  wire       start,
    input  wire       done

    output wire       cnt_bit_max,
    output reg  [6:0] cnt_byte,
    output wire       scl_high,
    output wire       scl_low,
);
//=============================================================================
reg start_en;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        start_en <= 1'b0;
    end 
    else if (start) begin
        start_en <= 1'b1;
    end
    
    if (done) begin
        start_en <= 1'b0;
    end
end
//=============================================================================
wire cnt_bit_update = (cnt_clk == 7'd49);
reg [6:0] cnt_clk;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        cnt_clk <= 7'b0;
    end
    else if (start_en) begin
        if (cnt_clk == 7'd99) begin
           cnt_clk <= 7'd0; 
        end
        else begin
            cnt_clk <= cnt_clk + 7'd1;
        end
    end
end
//=============================================================================
reg [3:0] cnt_bit;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        cnt_bit <= 4'hF;
    end
    else if (!start_en) begin
        cnt_bit <= 4'hF;
    end
    else if (cnt_bit_max) begin
        cnt_bit <= 4'd0;
    end
    else if (cnt_bit_update) begin
        cnt_bit <= cnt_bit + 4'd1;
    end
end

assign cnt_bit_max = (cnt_bit == 4'd9);
//=============================================================================
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        cnt_byte <= 7'b0;
    end
    else if (done) begin
        cnt_byte <= 7'd0;
    end
    else if (cnt_bit_max) begin
        cnt_byte <= cnt_byte + 7'b1;
    end
end
//=============================================================================
assign scl_high = (cnt_clk < 50);
assign scl_low  = (cnt_clk >= 50) && (cnt_clk < 100);

endmodule