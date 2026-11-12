module sign_magnitude_to_twos_complement(
    output reg [15:0] twos_complement,
    input [15:0] sign_magnitude
    );
    reg [15:0] n, sum;
    
    always @(*)
        begin
            n = ~(sign_magnitude[14:0]);
            sum = n+16'b1;
            
            if (sign_magnitude[15]) begin
                twos_complement = sum;
            end
            else begin
                twos_complement = sign_magnitude;
            end
            
        end
endmodule
