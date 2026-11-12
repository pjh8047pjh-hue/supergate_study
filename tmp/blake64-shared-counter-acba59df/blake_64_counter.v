
module blake_64_counter (
	input  wire clk,    
	input  wire rstb,   
	input  wire cnt_en_g0,
    input  wire cnt_en_g1,

	output wire [6:0] counter_g0,
    output wire [6:0] counter_g1,
    output reg  done_g0,
    output reg  done_g1
);

// Shared counter for inputs spaced exactly 64 clocks apart
reg [6:0] counter;

always @(posedge clk or negedge rstb) begin
    if (!rstb)
        counter <= 7'd0;
    else if (cnt_en_g0 || cnt_en_g1)
        counter <= counter + 7'd1;
    else
        counter <= 7'd0;
end

assign counter_g0 = counter;
assign counter_g1 = {~counter[6], counter[5:0]};
//------------ done flag --------------
always @(posedge clk or negedge rstb) begin
    if (!rstb) begin
        done_g0 <= 1'b0;
        done_g1 <= 1'b0;
    end
    else begin
        done_g0 <= cnt_en_g0 && (counter_g0 == 7'd126);
        done_g1 <= cnt_en_g1 && (counter_g1 == 7'd126);
    end
end

endmodule //: blake_counter
