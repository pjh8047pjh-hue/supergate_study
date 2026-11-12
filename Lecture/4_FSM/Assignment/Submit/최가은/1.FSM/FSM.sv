module FSM(
    input data_in, reset, clk,
    output data_out);
    
    reg [2:0] Current; //, Next;
    
    parameter [2:0] A = 0, B = 1, C = 2, D = 3 , E = 4;
    
    always @(posedge clk or negedge reset) begin
        data_out <= 0;
        if (~reset) begin
            Current <= A; 
        end
        else 
            //Current <= Next;
            data_out <= 0;
            case(Current)
                A : if (data_in)  Current <= C;
                    else          Current <= B;
                B : if (data_in)  Current <= D;
                C : if (~data_in) Current <= E;
                D : begin
                    data_out <= 1;
                    if (data_in)  Current <= C;
                    else          Current <= E;
                end
                E : begin
                    data_out <= 1;
                    if (data_in)  Current <= D;
                    else          Current <= B;
                end
                default : Current <= A;
            endcase
    end
    
endmodule 