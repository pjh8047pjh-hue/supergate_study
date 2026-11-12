`define TRUE 1'b1
`define FALSE 1'b0

//Stimulus Module
module tb_sig_control;
	wire [1:0] MAIN_SIG, CNTRY_SIG;
	reg CAR_ON_CNTRY_RD;

	//if TRUE, indicates that there is car on
	//the country road

	reg CLOCK, CLEAR;
	//Instantiate signal controller
	sig_control SC(MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD, CLOCK, CLEAR);

	//Setup monitor
	initial
		begin
		$display("00=Red\n01=Yellow\n10=Green");
		$monitor("Highway = %b,Farmway = %b, X_signal = %b",
			MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD);
		end

	//setup clock
	initial
		begin
			CLOCK = `FALSE;
			forever #5 CLOCK = ~CLOCK;
		end

	//control clear signal
	initial
		begin
			CLEAR = `TRUE;
			repeat(5) @(negedge CLOCK);
			CLEAR = `FALSE;
		end
	//apply stimulus
	initial
		begin
			CAR_ON_CNTRY_RD = `FALSE;
			repeat(20) @(negedge CLOCK); CAR_ON_CNTRY_RD = `TRUE;
			repeat(10) @(negedge CLOCK); CAR_ON_CNTRY_RD = `FALSE;
			repeat(20) @(negedge CLOCK); CAR_ON_CNTRY_RD = `TRUE;
			repeat(10) @(negedge CLOCK); CAR_ON_CNTRY_RD = `FALSE;
			repeat(20) @(negedge CLOCK); CAR_ON_CNTRY_RD = `TRUE;
			repeat(10) @(negedge CLOCK); CAR_ON_CNTRY_RD = `FALSE;
			repeat(10) @(negedge CLOCK); $stop;
		end

endmodule

