`timescale 1ns/10ps
module state_case_tb;
    reg [6:0] counter;
    reg [1023:0] V;
    wire [63:0] a, b, c, d;
    wire [3:0] sel_a, sel_b, sel_c, sel_d;
    integer i, j, g, ia, ib, ic, id;
    integer errors = 0;
    blake_rtl_state_mux dut(counter, V, a, b, c, d,
                            sel_a, sel_b, sel_c, sel_d);
    initial begin
        for (j = 0; j < 16; j = j + 1)
            V[1023-j*64 -: 64] = 64'h0123456789abcdef ^ j;
        for (i = 0; i < 128; i = i + 1) begin
            counter = i;
            g = i & 7;
            ia = g & 3;
            ib = 4 + ((g < 4) ? g : ((g-3) & 3));
            ic = 8 + ((g < 4) ? g : ((g-2) & 3));
            id = 12 + ((g < 4) ? g : ((g-1) & 3));
            #1;
            if (sel_a !== ia[3:0] || sel_b !== ib[3:0]
                || sel_c !== ic[3:0] || sel_d !== id[3:0]
                || a !== V[1023-ia*64 -: 64]
                || b !== V[1023-ib*64 -: 64]
                || c !== V[1023-ic*64 -: 64]
                || d !== V[1023-id*64 -: 64]) begin
                errors = errors + 1;
                $display("FAIL at counter %0d", i);
            end
        end
        $display("STATE CASE: 128 counters checked, errors=%0d", errors);
        $finish;
    end
endmodule
