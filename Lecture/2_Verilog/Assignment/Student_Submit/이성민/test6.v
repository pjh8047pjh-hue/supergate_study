module sequence_detector_fsm_tb;

reg clk = 0;
reg reset_n = 0;
reg data_in = 0;

wire data_out;

seq_detector I0(data_out, data_in, reset_n, clk);

// Set clock.
always #5 clk = ~clk;
always #10 $display($time, " reset_n: %b, data_in: %b, data_out: %b, state: %b",
                    reset_n, data_in, data_out, I0.state);

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


module seq_detector (data_out, data_in, reset_n, clk); 

output data_out;
input data_in;
input clk, reset_n;
reg data_out;
reg[1:0] state;
parameter s0=2'd0, s1=2'd1, s2=2'd2, s3=2'd3, s4=2'd4;

always @(posedge clk or negedge reset_n)
    if(reset_n==0) begin state=s0; data_out=0; end
    else begin
    case (state)
        s0: begin data_out=0; if(data_in==0) state=s0; else state=s1; end
        s1: begin data_out=0; if(data_in==0) state=s0; else state=s2; end
        s2: begin data_out=0; if(data_in==0) state=s0; else state=s3; end
        s3: begin data_out=0; if(data_in==0) state=s0; else state=s4; end
        s4: begin data_out=1; if(data_in==0) state=s0; else state=s4; end
        default: state=s0;
    endcase
end
endmodule
