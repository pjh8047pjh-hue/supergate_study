module sequence_detector_fsm_tb;

reg clk = 0;
reg reset_n = 0;

wire data_out;

seq_generator fsm(data_out, reset_n, clk);

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



module seq_generator (data_out, reset_n, clk);
output reg data_out;
input reset_n, clk;

reg state;

parameter s0=2'd0, s1=2'd1, s2=2'd2, s3=2'd3, s4=2'd4, s5=2'd5, s6=2'd6, s7=2'd7, s8=2'd8, s9=2'd9, s10=2'd10;

always @(posedge clk or negedge reset_n)
    if(reset_n==0) begin state=s0; data_out=0; end
    else begin
    case (state)
    s0 : begin data_out = 0; state <= s1; end
    s1 : begin data_out = 1; state <= s2; end
    s2 : begin data_out = 0; state <= s3; end
    s3 : begin data_out = 0; state <= s4; end
    s4 : begin data_out = 1; state <= s5; end
    s5 : begin data_out = 0; state <= s6; end
    s6 : begin data_out = 1; state <= s7; end
    s7 : begin data_out = 1; state <= s8; end
    s8 : begin data_out = 0; state <= s9; end
    s9 : begin data_out = 0; state <= s10; end
    s10 : begin data_out = 1; state <= s0; end
    default: state=s0;
    endcase
end
endmodule
