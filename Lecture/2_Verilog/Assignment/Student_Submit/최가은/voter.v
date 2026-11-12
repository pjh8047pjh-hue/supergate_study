module voter(
    output reg [2:0] out,
    input [2:0] agree
    );
    reg [2:0] sum1, sum2, sum3;
    always @(*)
        begin
            sum1 = agree[0]&agree[1];
            sum2 = agree[1]&agree[2];
            sum3 = agree[0]&agree[2];
            out = sum1|sum2|sum3; 
        end
        
endmodule
