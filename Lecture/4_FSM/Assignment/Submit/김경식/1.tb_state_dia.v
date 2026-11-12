`define TRUE 1'b1
`define FALSE 1'b0

module tb_state_dia;
	wire[2:0] STATE;
	wire OUT;
	reg SELECT;
	reg CLOCK, RESET;

	state_dia SD(STATE,OUT,SELECT,CLOCK,RESET);

	//set_up monitor
	initial
	begin
		$display("000=A\n001=B\n010=C\n011=D\n100=E");
		$monitor("State = %b, Out = %b, Next = %b", SD.current_state, OUT, SELECT);
	end
	//set_up clock
	initial
		begin
			CLOCK = `FALSE;
			forever #5 CLOCK = ~CLOCK;
		end

	//control reset signal
	initial
		begin
			RESET = `TRUE;
			repeat(5) @(negedge CLOCK);
			RESET = `FALSE;
		end

	//applay stimulus
	initial
		begin
			SELECT = `FALSE;
			repeat(20) @(negedge CLOCK); SELECT = `TRUE;
			repeat(10) @(negedge CLOCK); SELECT = `FALSE;
			repeat(20) @(negedge CLOCK); SELECT = `TRUE;
			repeat(10) @(negedge CLOCK); SELECT = `FALSE;
			repeat(20) @(negedge CLOCK); SELECT = `TRUE;
			repeat(10) @(negedge CLOCK); SELECT = `FALSE;
			repeat(10) @(negedge CLOCK); $finish;
		end
endmodule

		
