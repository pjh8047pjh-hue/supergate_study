module uart_edge_detecter (
	input clk,   
	input rstb,  
	input ser_in,

	output ser_sync,
	output ser_fall
);

//=============================================================================
// edge detecter
wire ser_fall;
wire ser_rise;

reg  [1:0] ser_d2; 

always @(posedge clk or negedge rstb) begin
 	if(~rstb) begin
 		ser_d2 <= 2'b0;
 	end else begin
 		ser_d2 <= {ser_d2[0], ser};
 	end
end

assign ser_sync = ser_d2[1];
assign ser_fall = (~ser_d2[0] &&  ser_d2[1]);
//=============================================================================

endmodule //: edge_detecter
