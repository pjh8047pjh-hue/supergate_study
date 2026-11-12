module ass_i2c_slave_scl_counter (
	input clk,    // Clock
	input rstb,  // Asynchronous reset active low
	input init_0,
	input cnt_inc,
	input cnt_max,
	
	output reg [3:0] cnt_scl
);

// cnt_scl
always @(posedge clk or negedge rstb) begin
    if (!rstb) begin
        cnt_scl <= 4'd0;
	end
    else if (init_0) begin
        cnt_scl <= 4'd0;
	end
    else if (cnt_inc) begin
        cnt_scl <= cnt_max ? 4'd0 : cnt_scl + 1'b1;
	end
end


endmodule //: scl_counter