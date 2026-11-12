

module test2_tb;

reg clk = 0;
reg rst = 0;
reg X = 0;
wire[1:0] hwy,fwy;

test2 I0(hwy, fwy, X, clk, rst);

always #5 clk = ~clk;
always #10 $display($time, " reset: %b, X: %b, hwy: %b, fwy: %b, state1: %b",
                    rst, X, hwy, fwy, I0.state1);
                    
// Test data.
initial begin
    #2 rst = 1;
    X = 0;
    #10 X = 0;
    #10 X = 1;
    #10 X = 0;
    #10 X = 1;
    #10 X = 1;
    #10 X = 1;
    #10 X = 1;
    #10 X = 0;
    #10 X = 0;
    #10 X = 0;
    
    $finish;
end

endmodule

module test2(hwy, fwy, X, clk, rst);
input X,rst,clk;
output reg[1:0] hwy, fwy;

reg[2:0] state1;//hwy
reg[2:0] state2;//fwy

parameter   S0=2'd0, 
            S1=2'd1,
            S2=2'd2,
            S3=2'd3;

            
always @(posedge clk or negedge rst)
    if(rst ==0) begin state1=S0; hwy=2'd2; end 
    else begin 
    case(state1)
    S0: begin hwy=2'd2; if(X==0) state1=S0; else state1=S1; end
    S1: begin hwy=2'd1; state1=S2; end
    S2: begin hwy=2'd0; if(X==0) state1=S3; else state1=S2; end
    S3: begin hwy=2'd0; state1=S0; end
        default: state1=S0;
    endcase
end

always @(posedge clk or negedge rst)
    if(rst ==0) begin state2=S0; fwy=2'd0; end
    else begin 
    case(state2)
    S0: begin fwy=2'd0; if(X==0) state2=S0; else state2=S1; end
    S1: begin fwy=2'd0; state2=S2; end
    S2: begin fwy=2'd2; if(X==0) state2=S3; else state2=S2; end
    S3: begin fwy=2'd1; state2=S0; end
        default: state2=S0;
    endcase
end

endmodule

