module ass_uart_serdes_fsm_counter (
	input  clk, 
	input  rstb,
	input  init,
	input  bclk,
	input  [7:0] length,

	output data_en,
	output frame_done,
	output done
);

localparam OCR_DIV = 4'd15; // OCR = 16, sampling timing is 8 blck.
//=============================================================================
// cnt_bclk 16
reg [3:0] cnt_bclk;

always @(posedge clk or negedge rstb) begin
    if (!rstb) begin
        cnt_bclk <= 4'd0;
	end
	else if (init) begin
        cnt_bclk <= 4'd0;
	end
    else if (bclk) begin
        cnt_bclk <= (cnt_bclk == OCR_DIV) ? 4'd0 : cnt_bclk + 1'b1;
	end
end
//=============================================================================
// count bit 
reg [3:0] cnt_bit;

always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		cnt_bit <= 4'b0;
	end 
	else if(init || frame_done) begin
		cnt_bit <= 4'b0;
	end 
	else if(sampling) begin
		cnt_bit <= cnt_bit + 4'b1;
	end
end
//=============================================================================
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
//=============================================================================
// output control signal
assign done        = (cnt_frame == length);          // communication the end
assign frame_done  = sampling && (cnt_bit  == 4'd9); // length of 1 frame by bit
assign sample_tick = bclk && (cnt_bclk == 4'd7);     // data sampling time
assign sampling    = sampling && ((cnt_bit > 4'd0) && (cnt_bit < 4'd9)); // except start bit
assign data_en     = sample_tick && (cnt_bit == 4'd7); // data is available

endmodule 