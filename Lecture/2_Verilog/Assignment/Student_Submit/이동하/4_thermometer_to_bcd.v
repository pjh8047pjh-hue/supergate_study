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

module thermometer_to_bcd(output reg [7:0] bcd, input [15:0] thermometer);

initial begin

if(thermometer==1)
bcd = 8'b00000000;

else if(thermometer==3)
bcd = 8'b00000001;

else if(thermometer==7)
bcd = 8'b00000010;

else if(thermometer==15)
bcd = 8'b00000011;

else if(thermometer==31)
bcd = 8'b00000100;

else if(thermometer==63)
bcd = 8'b00000101;

else if(thermometer==127)
bcd = 8'b00000110;

else if(thermometer==255)
bcd = 8'b00000111;

else if(thermometer==511)
bcd = 8'b00001000;

else if(thermometer==1023)
bcd = 8'b00001001;

else if(thermometer==2047)
bcd = 8'b00001010;

else if(thermometer==5091)
bcd = 8'b00001011;

else if(thermometer==10183)
bcd = 8'b00001100;

else if(thermometer==20367)
bcd = 8'b00001101;

else if(thermometer==40735)
bcd = 8'b00001110;

else if(thermometer==81471)
bcd = 8'b00001111;

else
bcd = 8'b00010000;

end

endmodule