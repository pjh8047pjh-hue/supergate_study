
module blake_64_counter (
	input  wire clk,    
	input  wire rstb,   
	input  wire cnt_en_g0,
    input  wire cnt_en_g1,

	output reg  [6:0] counter_g0,
    output reg  [6:0] counter_g1,
    output reg  done_g0,
    output reg  done_g1
);

//------------- count logic ------------------
always @(posedge clk or negedge rstb) begin
    if (~rstb) begin 
        counter_g0 <= 7'd0;
    end
    else if (cnt_en_g0) begin
        counter_g0 <= counter_g0 + 7'd1;
    end
    else begin
        counter_g0 <= 7'd0;
    end
end

always @(posedge clk or negedge rstb) begin
    if (~rstb) begin 
        counter_g1 <= 7'd0;
    end
    else if (cnt_en_g1) begin
        counter_g1 <= counter_g1 + 7'd1;
    end
    else begin
        counter_g1 <= 7'd0;
    end
end
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

