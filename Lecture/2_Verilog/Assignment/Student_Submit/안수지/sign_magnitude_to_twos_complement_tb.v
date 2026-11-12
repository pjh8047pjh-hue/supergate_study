module sign_magnitude_to_twos_complement (twos_complement, sign_magnitude);
input [15:0] sign_magnitude;
output reg [15:0] twos_complement;

always @ (sign_magnitude[15], sign_magnitude[14:0])
begin
if (sign_magnitude[15]==1)
    twos_complement = (~sign_magnitude[14:0]+1);
   else
    twos_complement = sign_magnitude;
end

endmodule



module sign_magnitude_to_twos_complement_tb;

wire signed [15:0] twos_complement;
reg [15:0] sign_magnitude = 0;

sign_magnitude_to_twos_complement translator(twos_complement, sign_magnitude);

initial begin
    $monitor("%d - sign_magnitude: %b, 2's complement: %b",
             twos_complement, sign_magnitude, twos_complement);

    #5 sign_magnitude = 16'b1101;
    #5 sign_magnitude = 16'b0011_1111;
    #5 sign_magnitude = 16'b1000_0000_0000_0000;
    #5 sign_magnitude = 16'b1000_0000_1001_0101;
    #5 sign_magnitude = 16'b1000_0000_1111_1111;
    #5 sign_magnitude = 16'b1111_1111_1111_1111;
end

endmodule
