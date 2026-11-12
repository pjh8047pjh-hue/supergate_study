`timescale 1ns/10ps
module sigma_case_tb;
    reg [6:0] counter;
    reg [639:0] msg;
    wire [63:0] m0, m1, c0, c1;
    integer i;
    integer errors = 0;
    reg [3:0] expected0, expected1;
    blake_rtl_msg_mux dut(counter, msg, m0, m1, c0, c1);
    initial begin
        msg = 640'd0;
        for (i = 0; i < 128; i = i + 1) begin
            counter = i;
            #1;
            expected0 = dut.SIGMA[i*8 +: 4];
            expected1 = dut.SIGMA[i*8+4 +: 4];
            if (dut.sigma0 !== expected0 || dut.sigma1 !== expected1) begin
                errors = errors + 1;
                $display("FAIL at counter %0d", i);
            end
        end
        $display("SIGMA CASE: 128 selections checked, errors=%0d", errors);
        $finish;
    end
endmodule
