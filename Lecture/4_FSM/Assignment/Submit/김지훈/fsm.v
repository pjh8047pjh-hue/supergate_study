

module fsm(out, in, rst, clk);

output out;
input in, rst, clk;


parameter [1:0] a=0, b=1, c=2, d=3, e=4;


reg [2:0] state;

// Update state.
/*always @(posedge clk or negedge rst) begin
    if (~rst)
        state <= a;
    else
        state <= next_state;
end




// Calculate next state.
always @(state, data_in) begin
    case (state)
        3'd0: next_state = (data_in ? 3'd1 : 3'd0);
        3'd1: next_state = (data_in ? 3'd2 : 3'd0);
        3'd2: next_state = (data_in ? 3'd3 : 3'd0);
        3'd3: next_state = (data_in ? 3'd4 : 3'd0);
        3'd4: next_state = (data_in ? 3'd4 : 3'd0);
        default: next_state = 3'd0;
    endcase
end */


// Calculate data_out.


// Code Style 2
//
always @(posedge clk or negedge rst) begin
  if (~rst) begin
        state <= 0;
    end // if

    else begin

        case (state)
            0: state = (in ? 2 : 1);
            1: state = (in ? 3 : 1);
            2: state = (in ? 2 : 4);
            3: state = (in ? 2 : 4);
            4: state = (in ? 3 : 1);
            default: state = 0;

        endcase                     //state


    end // begin


end // always


assign out = (state == 3) ? 1 :
             (state == 4) ? 1 :
             0;
             


endmodule

