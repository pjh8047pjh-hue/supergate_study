
`timescale 1ns / 10ps

module blake_64_2_state_mux  (
  input  [5:0] count,
  input  [1023:0] state ,

  output reg [63:0] a,
  output reg [63:0] b,
  output reg [63:0] c,
  output reg [63:0] d
);

always @(*)
begin
  case (count[2:0])
    3'h0: a = state[64*15 +: 64];
    3'h1: a = state[64*14 +: 64];
    3'h2: a = state[64*13 +: 64];
    3'h3: a = state[64*12 +: 64];
    3'h4: a = state[64*15 +: 64];
    3'h5: a = state[64*14 +: 64];
    3'h6: a = state[64*13 +: 64];
    3'h7: a = state[64*12 +: 64];
  endcase
end // always

always @(*)
begin
  case (count[2:0])
    3'h0: b = state[64*11 +: 64];
    3'h1: b = state[64*10 +: 64];
    3'h2: b = state[64*9  +: 64];
    3'h3: b = state[64*8  +: 64];
    3'h4: b = state[64*10 +: 64];
    3'h5: b = state[64*9  +: 64];
    3'h6: b = state[64*8  +: 64];
    3'h7: b = state[64*11 +: 64];
  endcase
end // always

always @(*)
begin
  case (count[2:0])
    3'h0: c = state[64*7 +: 64];
    3'h1: c = state[64*6 +: 64];
    3'h2: c = state[64*5 +: 64];
    3'h3: c = state[64*4 +: 64];
    3'h4: c = state[64*5 +: 64];
    3'h5: c = state[64*4 +: 64];
    3'h6: c = state[64*7 +: 64];
    3'h7: c = state[64*6 +: 64];
  endcase
end // always

always @(*)
begin
  case (count[2:0])
    3'h0: d = state[64*3 +: 64];
    3'h1: d = state[64*2 +: 64];
    3'h2: d = state[64*1 +: 64];
    3'h3: d = state[64*0 +: 64];
    3'h4: d = state[64*0 +: 64];
    3'h5: d = state[64*3 +: 64];
    3'h6: d = state[64*2 +: 64];
    3'h7: d = state[64*1 +: 64];
  endcase
end // always

endmodule