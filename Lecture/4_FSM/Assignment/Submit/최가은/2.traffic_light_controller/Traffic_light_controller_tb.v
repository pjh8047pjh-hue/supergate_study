module tb_sig_control;
wire [1:0] MAIN_SIG, CNTRY_SIG;
reg CAR_ON_CNTRY_RD;
 //if TRUE, indicates that there is car on
 //the country road
reg CLOCK, reset;
//Instantiate signal controller
light_controller SC(.X(CAR_ON_CNTRY_RD), .clock(CLOCK), .reset(reset), .hwy(MAIN_SIG), .fwy(CNTRY_SIG));
//Setup monitor
initial
 $monitor($time, "Main Sig = %b Country Sig = %b Car_on_cntry = %b",
 MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD);
//setup clock
initial
begin
 CLOCK = 1'b0;
 forever #5 CLOCK = ~CLOCK;
end
//control clear signal
initial
begin
 reset = 1'b1;
 repeat (5) @(negedge CLOCK);
 reset = 1'b0;
end
//apply stimulus
initial
begin
 CAR_ON_CNTRY_RD = 1'b0;
 repeat (20) @(negedge CLOCK); CAR_ON_CNTRY_RD = 1'b1;
 repeat (10) @(negedge CLOCK); CAR_ON_CNTRY_RD = 1'b0;
 repeat (20) @(negedge CLOCK); CAR_ON_CNTRY_RD = 1'b1;
 repeat (10) @(negedge CLOCK); CAR_ON_CNTRY_RD = 1'b0;
 repeat (20) @(negedge CLOCK); CAR_ON_CNTRY_RD = 1'b1;
 repeat (10) @(negedge CLOCK); CAR_ON_CNTRY_RD = 1'b0;
 repeat (10) @(negedge CLOCK); $stop;
end
endmodule