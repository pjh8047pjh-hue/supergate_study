module graduate_judger
    (
     output reg [3:0] eligible_to_graduate,  
     input [3:0] pass
        );
    reg [3:0] sum1, sum2;
    always @(*)
        begin
            sum1 = ~(pass[0]&pass[1]&pass[3]);
            sum2 = ~(pass[2]&pass[3]);
            eligible_to_graduate = ~(sum1&sum2);
        end
endmodule
