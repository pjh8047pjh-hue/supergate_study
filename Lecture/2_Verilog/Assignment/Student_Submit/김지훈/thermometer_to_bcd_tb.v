module thermometer_to_bcd(bcd, thermometer);

output [7:0] bcd;
input [15:0] thermometer;

reg [7:0] bcd;

always @ ( thermometer ) 


case ( thermometer )

16'b0000000000000000 : bcd = 8'b00000000;
16'b0000000000000001 : bcd = 8'b00000001;
16'b0000000000000011 : bcd = 8'b00000010;
16'b0000000000000111 : bcd = 8'b00000011;
16'b0000000000001111 : bcd = 8'b00000100;
16'b0000000000011111 : bcd = 8'b00000101;
16'b0000000000111111 : bcd = 8'b00000110;
16'b0000000001111111 : bcd = 8'b00000111;
16'b0000000011111111 : bcd = 8'b00001000;
16'b0000000111111111 : bcd = 8'b00001001;
16'b0000001111111111 : bcd = 8'b00010000;
16'b0000011111111111 : bcd = 8'b00010001;
16'b0000111111111111 : bcd = 8'b00010010;
16'b0001111111111111 : bcd = 8'b00010011;
16'b0011111111111111 : bcd = 8'b00010100;
16'b0111111111111111 : bcd = 8'b00010101;
16'b1111111111111111 : bcd = 8'b00010110;
default : bcd = 8'b00000000;

endcase
endmodule

module thermometer_to_bcd_tb;

wire [7:0] bcd;
reg [15:0] thermometer = 0;

thermometer_to_bcd translator(bcd, thermometer);

initial begin
    $monitor("thermometer: %b, bcd: %b, dec: %d%d",
             thermometer, bcd, bcd[7:4], bcd[3:0]);
    
    repeat (16) #5 thermometer = {thermometer[14:0], 1'b1};

    $finish;
end

endmodule



