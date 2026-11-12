module sequence_generator_fsm(data_out, clk, reset_n);

input clk, reset_n;

output reg data_out;

parameter s0 = 4'b0000, 
          s1 = 4'b0001, 
          s2 = 4'b0010,  
          s3 = 4'b0011,  
          s4 = 4'b0100, 
          s5 = 4'b0101,  
          s6 = 4'b0110, 
          s7 = 4'b0111, 
          s8 = 4'b1000,  
          s9 = 4'b1001,  
          s10 = 4'b1010;

reg [3:0] state;

always @(posedge clk or negedge reset_n)
begin

if (!reset_n)

state <= s0;

  case(state)

s0: state <= s1;

s1: state <= s2;

s2: state <= s3;

s3: state <= s4;

s4: state <= s5;

s5: state <= s6;

s6: state <= s7;

s7: state <= s8;

s8: state <= s9;

s9: state <= s10;

s0:
 state <= s0;


endcase

end

always @(state)

  case(state)

s0: data_out <= 0;

s1: data_out <= 1;

s2: data_out <= 0;

s3: data_out <= 0;

s4: data_out <= 1;

s5: data_out <= 0;

s6: data_out <= 1;

s7: data_out <= 1;

s8: data_out <= 0;

s9: data_out <= 0;

s10: data_out <= 1;

endcase

endmodule






module sequence_generator_fsm_tb;

reg clk = 0;
reg reset_n = 0;

wire data_out;

sequence_generator_fsm fsm(data_out, reset_n, clk);

// Set clock.
always #5 clk = ~clk;

// Test data.
initial begin
    $monitor($time, " data_out: %b, state: %b",
             data_out, fsm.state);

    #1 reset_n = 1;
    #200 $finish;
end

endmodule


