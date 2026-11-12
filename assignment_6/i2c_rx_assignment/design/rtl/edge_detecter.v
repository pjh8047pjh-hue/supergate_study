module edge_detecter (
	input clk,   
	input rstb,  
	input scl,
	input sda,

	output start,
	output stop,
	output scl_rise,
	output scl_fall,
	output reg [1:0] scl_d2,
	output sda_rise,
	output sda_fall,
	output reg [1:0] sda_d2
);

//=============================================================================
// edge detecter
always @(posedge clk or negedge rstb) begin
 	if(~rstb) begin
 		sda_d2 <= 2'b0;
 		scl_d2 <= 2'b0;
 	end else begin
 		sda_d2 <= {sda_d2[0], sda};
 		scl_d2 <= {scl_d2[0], scl};
 	end
end

assign scl_fall = (~scl_d2[0] &&  scl_d2[1]);
assign scl_rise = ( scl_d2[0] && ~scl_d2[1]);

assign sda_fall = (~sda_d2[0] &&  sda_d2[1]);
assign sda_rise = ( sda_d2[0] && ~sda_d2[1]);

assign start = scl_d2[0] && scl_d2[1] && sda_fall;
assign stop  = scl_d2[0] && scl_d2[1] && sda_rise;
//=============================================================================

endmodule //: edge_detecter
