

module traffic(hwy_r, hwy_y, hwy_g, fwy_r, fwy_y, fwy_g, x, rst, clk);

output hwy_r, hwy_y, hwy_g, fwy_r, fwy_y, fwy_g ;

input x, rst, clk;


parameter [1:0] a=0, b=1, c=2, d=3;


reg [1:0] state;

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
    end //
    else begin
        case (state)

            0 : state = (x ? 1 : 0);
            1 : state = 2;
            2 : state = (x ? 2 : 3);
            3 : state = 0;
            default: state =   0;

        endcase

     end // if

  end // always


assign {hwy_r, hwy_y, hwy_g, fwy_r, fwy_y, fwy_g} = (state == 0) ? 6'b001100 :
                                                    (state == 1) ? 6'b010100 :
                                                    (state == 2) ? 6'b100001 :
                                                    (state == 3) ? 6'b100010 :
                                                    6'b000000;

endmodule

