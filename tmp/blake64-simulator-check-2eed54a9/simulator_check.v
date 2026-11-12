`timescale 1ns/10ps
module simulator_check;
  tb t();
  integer result_index = 0;
  reg [1023:0] saved_state;
  reg [511:0] saved_hash;
  localparam [511:0] IV = {64'h6A09E667F3BCC908,64'hBB67AE8584CAA73B,64'h3C6EF372FE94F82B,64'hA54FF53A5F1D36F1,64'h510E527FADE682D1,64'h9B05688C2B3E6C1F,64'h1F83D9ABFB41BD6B,64'h5BE0CD19137E2179};
  always @(posedge t.rdy) begin
    #1;
    saved_state = t.dut.done_g0 ? t.dut.state_0 : t.dut.state_1;
    saved_hash = IV ^ saved_state[1023:512] ^ saved_state[511:0];
    $display("CHECK hash=%0d dout_matches=%0d state_register_hash_matches=%0d at %0t", result_index, t.dout === t.ref[result_index], saved_hash === t.ref[result_index], $time);
    result_index = result_index + 1;
  end
  initial begin #4000; $display("CHECK total_results=%0d",result_index); $finish; end
endmodule
