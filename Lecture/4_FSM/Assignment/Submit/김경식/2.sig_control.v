`define TRUE 1'b1
`define FALSE 1'b0

//Delays
`define Y2RDELAY 3 //Yellow to red delay
`define R2GDELAY 2 //Red to Green delay

module sig_control(hwy,fwy,X,clock,clear);

	//I/O ports
	output [1:0] hwy,fwy;

	//2 bit output for 3 states of signal
	//GREEn, YELLOW, RED
	reg [1:0]hwy, fwy;

	//declare output signals are registers
	input X;

	//if TRUE, indicates that there is car on
	//the country road, otherwise FALSE
	input clock, clear;

	//Status of lights
	parameter RED = 2'd0,
		  YELLOW = 2'd1,
		  GREEN = 2'd2;

	//State definition HWY fwy
	parameter S0 = 3'd0, //GREEN RED
		  S1 = 3'd1, //YELLOW RED
		  S2 = 3'd2, //RED GREEN
		  S3 = 3'd3; //RED YELLOW

	//Internal state variables
	reg [2:0] state;
	reg [2:0] next_state;

	//State changes only at positive edge of clock
	always @(posedge clock or posedge clear)
		if(clear)
			state <= S0;
		else
			state <= next_state;

	//Compute values of main signal and country signal
	always @(state)
		begin
			hwy = GREEN; //Default light assignment
			fwy = RED; //Default light assignment
		case(state)
			S0: ;
			S1: hwy = YELLOW;
			S2: begin
				hwy = RED;
				fwy = GREEN;
			end
			S3: begin
				hwy = RED;
				fwy = YELLOW;
			end
		endcase
		end

	//State machine using case statements
	always @(state or X)
		begin
		case(state)
			S0 : if(X)
			next_state = S1;
			else
			next_state = S0;
			S1: begin //delay some positive edges of clock
				repeat(`Y2RDELAY) @(posedge clock);
			next_state = S2;
			end
			S2: if(X)
			next_state = S2;
			else
			next_state = S3;
			S3: begin //delay some positive edges of clock
				repeat(`Y2RDELAY) @(posedge clock);
			next_state = S0;
			end
			default: next_state = S0;
		endcase
		end
endmodule

	
