

module FSM1 (

input clk,
input rstb,
input show_rom,

output reg read,
output reg write

);


localparam [1:0] st_read  = 2'b00;
localparam [1:0] st_write = 2'b01;
localparam [1:0] st_delay = 2'b10;

reg [1:0] current_state, next_state;


// Current State (Sequential)
always @(posedge clk or negedge rstb)
begin
  if (~rstb) current_state <= st_read;
  else current_state <= next_state;
end // always


// Next State (Combinational)
always @(*)
begin

  case (current_state)
    st_read:  begin
      next_state = st_write;
    end //
    st_write: begin
      if (show_rom)
        next_state = st_delay;
      else
        next_state = st_read;
    end
    st_delay: begin
      next_state = st_read;
    end
    default : begin
      next_state = st_read;
    end
  endcase

end // always

// Output Logic (Combinational)
always @(*)
begin

  case (current_state)
    st_read:  begin
      read = 1'b1;
      write = 1'b0;
    end //
    st_write: begin
      read = 1'b0;
      write = 1'b1;
    end
    st_delay: begin
      read = 1'b0;
      write = 1'b0;
    end
    default : begin
      read = 1'b0;
      write = 1'b0;
    end
  endcase

end // always


endmodule


