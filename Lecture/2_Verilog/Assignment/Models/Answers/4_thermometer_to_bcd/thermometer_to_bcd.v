
// thermometer: 0000000000000000, bcd: 00000000, dec:  0 0
// thermometer: 0000000000000001, bcd: 00000001, dec:  0 1
// thermometer: 0000000000000011, bcd: 00000010, dec:  0 2
// thermometer: 0000000000000111, bcd: 00000011, dec:  0 3
// thermometer: 0000000000001111, bcd: 00000100, dec:  0 4
// thermometer: 0000000000011111, bcd: 00000101, dec:  0 5
// thermometer: 0000000000111111, bcd: 00000110, dec:  0 6
// thermometer: 0000000001111111, bcd: 00000111, dec:  0 7
// thermometer: 0000000011111111, bcd: 00001000, dec:  0 8
// thermometer: 0000000111111111, bcd: 00001001, dec:  0 9
// thermometer: 0000001111111111, bcd: 00001001, dec:  0 9
// thermometer: 0000011111111111, bcd: 00010000, dec:  1 0
// thermometer: 0000111111111111, bcd: 00010001, dec:  1 1
// thermometer: 0001111111111111, bcd: 00010010, dec:  1 2
// thermometer: 0011111111111111, bcd: 00010011, dec:  1 3
// thermometer: 0111111111111111, bcd: 00010100, dec:  1 4

module thermometer_to_bcd(bcd, thermometer);

output [7:0] bcd;
input [15:0] thermometer;


// Code 1:
reg [7:0] out;
always @(*)
begin
      case (thermometer)
            16'b0000_0000_0000_0000: out = 8'b0000_0000;
            16'b0000_0000_0000_0001: out = 8'b0000_0001;
            16'b0000_0000_0000_0011: out = 8'b0000_0010;
            16'b0000_0000_0000_0111: out = 8'b0000_0011;
            16'b0000_0000_0000_1111: out = 8'b0000_0100;
            16'b0000_0000_0001_1111: out = 8'b0000_0101;
            16'b0000_0000_0011_1111: out = 8'b0000_0110;
            16'b0000_0000_0111_1111: out = 8'b0000_0111;
            16'b0000_0000_1111_1111: out = 8'b0000_1000;
            16'b0000_0001_1111_1111: out = 8'b0000_1001;
            16'b0000_0011_1111_1111: out = 8'b0000_1001;
            16'b0000_0111_1111_1111: out = 8'b0001_0000;
            16'b0000_1111_1111_1111: out = 8'b0001_0001;
            16'b0001_1111_1111_1111: out = 8'b0001_0010;
            16'b0011_1111_1111_1111: out = 8'b0001_0011;
            16'b0111_1111_1111_1111: out = 8'b0001_0100;
            default:               : out = 8'b0001_0110;
      endcase

end // always
assign bcd = out;



// code 2:
//assign bcd = (thermometer == 16'b0) ? 0 :
//             (thermometer == 16'b1) ? 1 :
//             (thermometer == 16'b11) ? 2 :
//             (thermometer == 16'b111) ? 3 :
//             (thermometer == 16'b1111) ? 4 :
//             (thermometer == 16'b11111) ? 5 :
//             (thermometer == 16'b111111) ? 6 :
//             (thermometer == 16'b1111111) ? 7 :
//             (thermometer == 16'b11111111) ? 8 :
//             (thermometer == 16'b111111111) ? 9 :
//             (thermometer == 16'b1111111111) ? 9 :
//             (thermometer == 16'b11111111111) ? {4'd1, 4'd0} :
//             (thermometer == 16'b111111111111) ? {4'd1, 4'd1} :
//             (thermometer == 16'b1111111111111) ? {4'd1, 4'd2} :
//             (thermometer == 16'b11111111111111) ? {4'd1, 4'd3} :
//             (thermometer == 16'b111111111111111) ? {4'd1, 4'd4} :
//             (thermometer == 16'b1111111111111111) ? {4'd1, 4'd5} :
//                                                     {4'd1, 4'd6};

endmodule
