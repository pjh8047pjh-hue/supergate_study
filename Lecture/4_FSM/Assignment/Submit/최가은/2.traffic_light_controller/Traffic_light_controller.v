module light_controller(
    input X, clock, reset,
    output reg [1:0] hwy, fwy
    );
    
    parameter RED = 2'd0 , YELLOW = 2'd1 , GREEN = 2'd2;
    parameter S0 = 2'd0, S1 = 2'd1, S2 = 2'd2, S3 = 2'd3;
    
    reg [1:0] state; //,next_state;
    
    always @(posedge clock) begin
        if(reset) begin
            state <= S0;
            hwy <= GREEN;
            fwy <= RED;
            end
        else
            //state <= next_state;
        case(state)
            S0 : if(X)
                state <= S1;
            else
                state <= S0;
            S1 : begin
                hwy <= YELLOW;
                repeat(3)@(posedge clock);
                state <= S2;
                end
            S2 : begin
                hwy <= RED;
                fwy <= GREEN;
                if (X)
                    state <= S2;
                else
                    state <= S3;
            end
            S3 : begin
                hwy <= RED;
                fwy <= YELLOW;
                repeat(3)@(posedge clock);
                state <= S0;
            end
            default : state <= S0; 
        endcase
        
    end
endmodule