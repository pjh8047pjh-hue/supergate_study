module sequence_detector_fsm(data_out, data_in, reset_n, clk);

input clk, reset_n, data_in;

output reg data_out; 

parameter zero=3'b000, one=3'b001, two=3'b010, three=3'b011, four=3'b100;

reg [2:0] state;


always @(posedge clk or negedge reset_n)

begin

if(!reset_n)

state <= zero;

  case(state)

zero:begin

  if(data_in)

    state <= one;

  else

    state<= zero;
end


one:begin

  if(data_in)

    state<= two;

  else

    state<= zero;
end


two:begin
  if(data_in)

    state<= three;

  else

    state<= zero;
end


three:begin
  if(data_in)

    state <= four;

  else

    state<= zero;
end

four:begin
  if(data_in)

    state<= four;

  else

    state<= zero;

end

default : state<= zero;

endcase

end

always @(state)
begin

   case(state)

zero:  data_out <= 0;

one:  data_out <= 0;
  
two:  data_out <= 0;

three:  data_out <= 0;

four:   data_out <= 1;

default : data_out <= 0;

endcase

end

endmodule

module sequence_detector_fsm_tb;

reg clk = 0;
reg reset_n = 0;
reg data_in = 0;

wire data_out;

sequence_detector_fsm fsm(data_out, data_in, reset_n, clk);

// Set clock.
always #5 clk = ~clk;
always #10 $display($time, " reset_n: %b, data_in: %b, data_out: %b, state: %b",
                    reset_n, data_in, data_out, fsm.state);

// Test data.
initial begin
    #2 reset_n = 1;
    data_in = 0;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0;

    $finish;
end

endmodule

