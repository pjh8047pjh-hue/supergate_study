module thermometer_to_bcd_tb;

wire [7:0] bcd;
reg [16:0] thermometer = 0;

thermometer_bcd I0(.sel(thermometer[16:0]), .out(bcd[7:0]));

initial begin
    $monitor("thermometer: %b, bcd: %b, dec: %d%d",
             thermometer, bcd, bcd[7:4], bcd[3:0]);
    
    repeat (16) #5 thermometer = {thermometer[16:0], 1'b1};

    $finish;
end

endmodule


module thermometer_bcd(sel,out);

input [16:0]sel;
output reg out;

always @(sel)
begin
        if(sel == 16'b0000000000000000)
    out = 8'b00000000;
        if(sel == 16'b0000000000000001)
    out = 8'b00000001;
        if(sel == 16'b0000000000000011)
    out = 8'b00000010;
        if(sel == 16'b0000000000001111)
    out = 8'b00000011;
        if(sel == 16'b0000000000011111)
    out = 8'b00000100;
        if(sel == 16'b0000000000111111)
    out = 8'b00000101;
        if(sel == 16'b0000000001111111)
    out = 8'b00000110;
        if(sel == 16'b0000000011111111)
    out = 8'b00000111;
        if(sel == 16'b0000000111111111)
    out = 8'b00001000;
        if(sel == 16'b0000001111111111)
    out = 8'b00001001;
        if(sel == 16'b0000011111111111)
    out = 8'b00010000;
        if(sel == 16'b0000111111111111)
    out = 8'b00010001;
        if(sel == 16'b0001111111111111)
    out = 8'b00010010;
        if(sel == 16'b0011111111111111)
    out = 8'b00010011;
        if(sel == 16'b0111111111111111)
    out = 8'b00010100;    
        if(sel == 16'b01111111111111111)
    out = 8'b00010101;
        if(sel == 16'b11111111111111111)
    out = 8'b00010110;

end


//always @(sel)
//	begin
//		case(sel)
//			0 :  out =8'b00000000;
//			1 :  out =8'b00000001;
//			2 :  out =8'b00000010;
//			3 :  out =8'b00000011;
//			4 :  out =8'b00000100;
//			5 :  out =8'b00000101;
//			6 :  out =8'b00000110;
//			7 :  out =8'b00000111;
//			8 :  out =8'b00001000;
//			9 :  out =8'b00001001;
//			10 :  out =8'b00010000;
//			11 :  out =8'b00010001;
//			12 :  out =8'b00010010;
//			13 :  out =8'b00010011;
//			14 :  out =8'b00010101;
//			15 :  out =8'b00010110;
//		endcase
//	end
endmodule

