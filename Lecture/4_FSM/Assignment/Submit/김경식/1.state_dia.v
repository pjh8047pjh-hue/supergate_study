`define TRUE 1'b1
`define FALSE 1'b0

module state_dia (State,Out,X,clock,reset);
	output[2:0] State;
	reg[2:0] State;

	output Out;
	reg Out;

	input X;
	input clock, reset;

	//State Encoding :Sequential
	parameter [2:0] ST0 = 0;
	parameter [2:0] ST1 = 1;
	parameter [2:0] ST2 = 2;
	parameter [2:0] ST3 = 3;
	parameter [2:0] ST4 = 4;

	reg [2:0] current_state, next_state;
 
	//current state (Sequential)
	always @(posedge clock or posedge reset)
		if(reset) begin 
			current_state <= ST0;
		end
		else 
			current_state <= next_state;

	always @(current_state or X)
	begin
		case(current_state)
			ST0: if(X)
				next_state = ST2;
			     else
				next_state = ST1;
			ST1: if(X)
				next_state = ST3;
			     else
				next_state = ST1;
			ST2: if(X)
				next_state = ST2;
			     else
				next_state = ST4;
			ST3: if(X)
				next_state = ST2;
			     else
				next_state = ST4;
			ST4: if(X)
				next_state = ST3;
			     else
				next_state = ST1;
			default : next_state = ST0;
		endcase
	end //end always

	always @(current_state)
	begin
		case(current_state)
			ST0: begin State = 3'b000; Out = `FALSE; end
			ST1: begin State = 3'b001; Out = `FALSE; end
			ST2: begin State = 3'b010; Out = `FALSE; end
			ST3: begin State = 3'b011; Out = `TRUE; end
			ST4: begin State = 3'b100; Out = `TRUE; end
//		default : Out = `FALSE;
		endcase
	end //end always
					
endmodule


