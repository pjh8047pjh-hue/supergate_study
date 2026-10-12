
module blake_counter (
	input  wire clk,    
	input  wire rstb,   
	input  wire cnt_en,

	output reg  [6:0] counter,
	output wire cnt_done
);

//------------- count logic ------------------
always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        counter <= 7'd0;
    end
    else if (cnt_en) begin
        counter <= counter + 7'd1;
    end
    else begin
        counter <= 7'd0;
    end
end

assign cnt_done = (counter == 7'd127);


endmodule : blake_counter
