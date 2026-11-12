`timescale 1ns/10ps
module waveform_check;
    tb t();
    integer fd;
    integer half;
    integer results = 0;
    integer errors = 0;
    integer loads0 = 0;
    integer loads1 = 0;
    integer steps0 = 0;
    integer steps1 = 0;

    always @(posedge t.clk) begin
        if (!t.rstb) begin
            steps0 = 0;
            steps1 = 0;
        end
        else begin
            if (t.dut.init_g0) begin
                loads0 = loads0 + 1;
                steps0 = 0;
            end
            else if (t.dut.cnt_en_g0)
                steps0 = steps0 + 1;
            if (t.dut.init_g1) begin
                loads1 = loads1 + 1;
                steps1 = 0;
            end
            else if (t.dut.cnt_en_g1)
                steps1 = steps1 + 1;
        end
    end

    always @(posedge t.rdy) begin
        #1;
        if (results >= 3)
            errors = errors + 1;
        else if (t.dout !== t.ref[results]) begin
            errors = errors + 1;
            $display("VERIFY gap=64 hash=%0d FAIL", results);
        end
        else
            $display("VERIFY gap=64 hash=%0d PASS at %0t", results, $time);
        results = results + 1;
    end

    initial begin
        fd = $fopen("trace.csv", "w");
        $fdisplay(fd, "half,clk,rstb,ena,cstate,counter_g0,counter_g1,init_g0,init_g1,cnt_en_g0,cnt_en_g1,done_g0,done_g1,rdy,steps0,steps1,din,msg_g0,msg_g1,state_0,state_1,dout,v0");
        #(635 - 10);
        for (half = -2; half <= 780; half = half + 1) begin
            #0.10;
            $fdisplay(fd, "%0d,%b,%b,%b,%0d,%0d,%0d,%b,%b,%b,%b,%b,%b,%b,%0d,%0d,%h,%h,%h,%h,%h,%h,%h",
                half, t.clk, t.rstb, t.ena, t.dut.u_blake_64_fsm.cstate,
                t.dut.counter_g0, t.dut.counter_g1, t.dut.init_g0, t.dut.init_g1,
                t.dut.cnt_en_g0, t.dut.cnt_en_g1, t.dut.done_g0, t.dut.done_g1,
                t.rdy, steps0, steps1, t.din, t.dut.msg_g0, t.dut.msg_g1,
                t.dut.state_0, t.dut.state_1, t.dout, t.dut.v0);
            #4.90;
        end
        $fclose(fd);
        if (results != 3 || loads0 != 2 || loads1 != 1)
            errors = errors + 1;
        $display("SUMMARY gap=64 results=%0d loads_g0=%0d loads_g1=%0d errors=%0d",
                 results, loads0, loads1, errors);
        $finish;
    end
endmodule