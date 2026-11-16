module ass_uart_serdes_counter (
	input  wire		  clk, 
	input  wire		  rstb,
	input  wire		  start,
	input  wire		  bclk,
		  
	output wire		  data_en,
	output wire		  tx_update,
	output wire		  sampling,
	output reg  [3:0] cnt_bit
);

localparam OCR_DIV = 4'd15; // OCR = 16, sampling timing is 8 blck.
//=============================================================================
// cnt_bclk 15
reg [3:0] cnt_bclk;

always @(posedge clk or negedge rstb) begin
    if (!rstb) begin
        cnt_bclk <= 4'd0;
	end
	else if (start) begin
        cnt_bclk <= 4'd0;
	end
    else if (bclk) begin
        cnt_bclk <= (cnt_bclk == OCR_DIV) ? 4'd0 : cnt_bclk + 1'b1;
	end
end
//=============================================================================
// count bit 
wire sample_tick;

always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		cnt_bit <= 4'b0;
	end 
	else if(start) begin
		cnt_bit <= 4'b0;
	end 
	else if(sample_tick) begin
		cnt_bit <= cnt_bit + 4'b1;
	end
end
//=============================================================================
/*
//frame counter for count byte length
reg [7:0] cnt_frame;

always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		cnt_frame <= 8'b0;
	end 
	else if(init || done) begin
		cnt_frame <= 8'b0;
	end 
	else if(frame_done) begin
		cnt_frame <= cnt_frame + 8'b1;
	end
end
*/
//=============================================================================
// output control signal
// assign frame_done  = sampling && (cnt_bit  == 4'd9); // length of 1 frame by bit
assign sample_tick = bclk && (cnt_bclk == 4'd7);       // data sampling time
assign sampling    = sample_tick && (cnt_bit > 4'd0);  // except start bit
assign data_en     = sample_tick && (cnt_bit == 4'd9); // data is available
assign tx_update   = bclk && (cnt_bclk == 4'd15);

endmodule