module sequence_detector(

output data_out,
input data_in,
input reset_n,
input clk
);

reg [2:0] state, next_state;

// Update state.
always @(posedge clk or negedge reset_n) begin
    if (~reset_n)
        state <= 3'b0;
    else
        state <= next_state;
end

// Calculate data_out.
assign data_out = (state == 3'd4 ? 1'b1 : 1'b0);

// Calculate next state.
always @(*) begin
    case (state)
        3'd0: next_state = (data_in ? 3'd1 : 3'd0);
        3'd1: next_state = (data_in ? 3'd2 : 3'd0);
        3'd2: next_state = (data_in ? 3'd3 : 3'd0);
        3'd3: next_state = (data_in ? 3'd4 : 3'd0);
        3'd4: next_state = (data_in ? 3'd4 : 3'd0);
        default: next_state = 3'd0;
    endcase
end


// Code Style 2
//
//always @(posedge clk or negedge reset_n) begin
//    if (~reset_n) begin
//        state <= 3'b0;
//    end //
//    else begin
//        case (state)
//            3'd0: state = (data_in ? 3'd1 : 3'd0);
//            3'd1: state = (data_in ? 3'd2 : 3'd0);
//            3'd2: state = (data_in ? 3'd3 : 3'd0);
//            3'd3: state = (data_in ? 3'd4 : 3'd0);
//            3'd4: state = (data_in ? 3'd4 : 3'd0);
//            default: state = 3'd0;
//        endcase
//    end
//end // always

endmodule
