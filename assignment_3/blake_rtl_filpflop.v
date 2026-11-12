module blake_rtl_filpflop (
	input  wire clk,   
	input  wire cnt_en,
	input  wire rstb,
	input  wire init,
	input  wire rdy,  
 
	input  wire [1023:0] v0,
    input  wire [1023:0] state_next,
	input  wire [ 639:0] msg_init,

	output  reg [ 639:0] msg,
	output  reg [1023:0] state
);

// Sequential - flip flop

always @(posedge clk or negedge rstb) begin
    if (!rstb) begin
        msg   <= 640'd0;
        state <= 1024'd0;
    end
    else if (rdy) begin
        msg   <= 640'd0;
        state <= 1024'd0;
    end
    else if (init) begin
        msg   <= msg_init;
        state <= v0;
    end
    else begin
        state <= state_next;
    end
end

endmodule //: blake_rtl_filpflop
