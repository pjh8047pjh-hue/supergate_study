`timescale 1ns/10ps
module timing_review_tb;
    tb base();
    integer errors = 0;
    integer i;
    reg [1023:0] expected_state;
    reg [639:0] saved_msg;
    reg [511:0] saved_hash;

    task check;
        input condition;
        input [511:0] label;
        begin
            if (condition !== 1'b1) begin
                errors = errors + 1;
                $display("FAIL: %0s at %0t", label, $time);
            end
        end
    endtask

    task verify_transaction;
        begin
            @(posedge base.clk);
            saved_msg = base.dut.msg_init;
            expected_state = base.dut.V;
            #0.1;
            check(base.dut.msg === saved_msg, "input captured on start edge");
            check(base.dut.state === expected_state, "initial state captured");
            check(base.dut.counter === 7'd0 && base.dut.cnt_en && !base.rdy,
                  "RUN starts at counter zero");
            for (i = 0; i < 128; i = i + 1) begin
                @(negedge base.clk);
                base.ena = 0;
                base.din = ~base.vec;
                #0.1;
                check(base.dut.counter === i[6:0], "G index before edge");
                expected_state = base.dut.state;
                expected_state[1023-base.dut.sel_a*64 -:64] =
                    base.dut.g_state[1023-base.dut.sel_a*64 -:64];
                expected_state[1023-base.dut.sel_b*64 -:64] =
                    base.dut.g_state[1023-base.dut.sel_b*64 -:64];
                expected_state[1023-base.dut.sel_c*64 -:64] =
                    base.dut.g_state[1023-base.dut.sel_c*64 -:64];
                expected_state[1023-base.dut.sel_d*64 -:64] =
                    base.dut.g_state[1023-base.dut.sel_d*64 -:64];
                @(posedge base.clk);
                #0.1;
                check(base.dut.state === expected_state,
                      "four words updated; remaining twelve held");
                check(base.dut.msg === saved_msg, "message held despite changed din");
                check(base.dut.counter === ((i+1) & 127), "counter advances with G");
                check(base.rdy === (i == 127), "ready follows last G update");
            end
            check(base.dout === base.ref, "reference hash matches after 128 G cycles");
            saved_hash = base.dout;
            $display("NORMAL: load + 128 G edges; final hash valid at %0t", $time);
            @(posedge base.clk);
            #0.1;
            check(!base.rdy && base.dout === 512'd0, "ready lasts one cycle");
            check(base.dut.state === 1024'd0 && base.dut.msg === 640'd0,
                  "message and state cleared after completion");
        end
    endtask

    task start;
        begin
            @(negedge base.clk);
            base.din = base.vec;
            base.ena = 1;
        end
    endtask

    initial begin
        #1;
        check(base.dut.msg === 640'd0 && base.dut.state === 1024'd0,
              "asynchronous reset clears storage");
        @(posedge base.ena);
        verify_transaction;
        start;
        verify_transaction;

        start;
        @(posedge base.clk);
        #0.1;
        @(posedge base.clk);
        #0.1;
        check(base.dut.state === base.dut.V && base.dut.counter === 7'd1,
              "two-cycle ena reloads with advanced counter");
        @(negedge base.clk);
        base.ena = 0;
        @(posedge base.rdy);
        #0.1;
        check(base.dout !== saved_hash, "two-cycle ena corrupts hash");
        $display("REPRODUCED: two-cycle ena skips G0 and produces wrong hash");
        @(posedge base.clk);
        #0.1;

        start;
        @(posedge base.clk);
        @(negedge base.clk);
        base.ena = 0;
        repeat (4) @(posedge base.clk);
        @(negedge base.clk);
        base.ena = 1;
        base.din = ~base.vec;
        @(posedge base.clk);
        #0.1;
        check(base.dut.state === base.dut.V && base.dut.counter === 7'd5
              && base.dut.cnt_en, "busy ena reloads without restarting counter");
        check(base.dut.msg !== saved_msg, "busy ena overwrites stored message");
        $display("REPRODUCED: ena during RUN overwrites message/state at counter 5");
        #1;
        base.rstb = 0;
        #0.1;
        check(base.dut.msg === 640'd0 && base.dut.state === 1024'd0
              && base.dut.counter === 7'd0 && !base.rdy && !base.dut.cnt_en,
              "asynchronous reset during RUN");
        $display("REVIEW COMPLETE: errors=%0d", errors);
        $finish;
    end
endmodule
