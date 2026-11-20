module ass_i2c_master_counter (
    input  wire       clk,
    input  wire       reset_n,
    input  wire       start,
    input  wire       done,
    input  wire [7:0] freq_i2c,

    output wire       shift,
    output wire       sampling,
    output reg  [6:0] cnt_byte,
    output wire       scl_update
);
//=============================================================================
reg start_en;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        start_en <= 1'b0;
    end     
    else if (done) begin
        start_en <= 1'b0;
    end
    else if (start) begin
        start_en <= 1'b1;
    end
end
//=============================================================================
reg [6:0] cnt_clk;
wire cnt_bit_update = (cnt_clk == 7'd49);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        cnt_clk <= 7'b0;
    end
    else if (start_en) begin
        if (cnt_clk == freq_i2c) begin
           cnt_clk <= 7'd0;
        end
        else begin
            cnt_clk <= cnt_clk + 7'd1;
        end
    end
end

assign sampling = (cnt_clk == 7'd24) ? 1'b1 : 1'b0;
//=============================================================================
reg [3:0] cnt_bit;
wire cnt_bit_max = (cnt_bit == 4'd8);

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
assign scl_update = (cnt_clk == 7'd49) || (cnt_clk == 7'd99);
assign shift      = (cnt_clk == 7'd74);

endmodule