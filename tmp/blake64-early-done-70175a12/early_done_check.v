`timescale 1ns/10ps
module early_done_check;
  tb t();
  integer results = 0;
  integer errors = 0;
  integer loads0 = 0;
  integer loads1 = 0;
  always @(posedge t.clk) begin
    if (t.rstb) begin
      if (t.dut.init_g0) loads0 = loads0 + 1;
      if (t.dut.init_g1) loads1 = loads1 + 1;
    end
  end
  always @(posedge t.rdy) begin
    #1;
    if (results >= 3) errors = errors + 1;
    else if (t.dout !== t.ref[results]) begin
      $display("SETTLED Hash[%0d] FAIL at %0t", results, $time);
      errors = errors + 1;
    end
    else $display("SETTLED Hash[%0d] PASS at %0t", results, $time);
    results = results + 1;
  end
  initial begin
    #4000;
    if (results != 3 || loads0 != 2 || loads1 != 1) errors = errors + 1;
    $display("SUMMARY results=%0d loads_g0=%0d loads_g1=%0d errors=%0d",results,loads0,loads1,errors);
    $finish;
  end
endmodule
