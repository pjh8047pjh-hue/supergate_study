

module FSM (

input clk,
input rstb,
input slow_rom,

output reg read,
output reg write

);

localparam [1:0] st_read  = 2'b00;
localparam [1:0] st_write = 2'b01;
localparam [1:0] st_delay = 2'b10;

reg [1:0] state;

always @(posedge clk or negedge rstb)
begin
  if (~rstb) begin
    state <= st_read;
  end
  else begin
    case (state)
      st_read : state <= st_write;
      st_write: state <= (slow_rom)? st_delay: st_read;
      st_delay: state <= st_read;
      default : state <= st_read;
    endcase
  end
end // always

assign read  = (state == st_read );
assign write = (state == st_write);



endmodule


