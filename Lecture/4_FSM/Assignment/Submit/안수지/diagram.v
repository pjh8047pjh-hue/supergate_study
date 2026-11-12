module diagram (data_out, data_in, reset_n, clk);

output data_out;
input data_in, reset_n, clk;

reg [2:0] state;
reg [2*10:1] char;
parameter A=3'b000, B=3'b001, C=3'b010, D=3'b011, E=3'b100;  
assign data_out = (state == D) ? 1 : 
                  (state == E) ? 1 :
                  0;
always @(posedge clk or posedge reset_n)
 begin
    if (reset_n) 
        state <= A;
 
    else
        case (state)
        A : state = (data_in ? C : B);
        B : state = (data_in ? D : B);
	C : state = (data_in ? C : E);
	D : state = (data_in ? C : E);
	E : state = (data_in ? D : B);
            default: state = A;
        endcase
end
always @(state)
begin 
case (state)
A : char =  "A";
B : char =  "B";
C : char =  "C";
D : char =  "D";
E : char =  "E";
endcase
	
end 

endmodule

