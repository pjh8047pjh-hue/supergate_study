module sequence_generator(
output data_out,
input  reset_n,
input  clk
);

reg out;
reg [2:0] state;
wire [2:0] next_state;

// Update state.
always @(posedge clk or negedge reset_n) begin
    if (~reset_n)
        state <= 0;
    else
        state <= next_state;
end

// Calculate next state.
assign next_state = (state == 10) ? 0 : state + 1;

// Calculate data_out.
// 01001011001
always @(state) begin
    case (state)
        0: out = 0;
        1: out = 1;
        2: out = 0;
        3: out = 0;
        4: out = 1;
        5: out = 0;
        6: out = 1;
        7: out = 1;
        8: out = 0;
        9: out = 0;
        10:out = 1;
        default: out = 0;
    endcase
end
assign data_out = out;

endmodule
