

module FSM1 (

input Clock,
input Reset,
input ShowRAM,

output reg Read,
output reg Write

);


parameter [1:0] ST_Read = 0, ST_Write = 1, ST_Delay = 2;

reg [1:0] CurrentState, NextState;


// Current State (Sequential)
always @(posedge Clock or negedge Reset)
begin
  if (~Reset) CurrentState <= ST_Read;
  else CurrentState <= NextState;
end // always


// Next State (Combinational)
always @(*)
begin

  case (CurrentState)
    ST_Read:  begin
      NextState = ST_Write;
    end //
    ST_Write: begin
      if (SlowRAM)
        NextState = ST_Delay;
      else
        NextState = ST_Read;
    end
    ST_Delay: begin
      NextState = ST_Read;
    end
    default : begin
      NextState = ST_Read;
    end
  endcase

end // always

// Output Logic (Combinational)
always @(*)
begin

  case (CurrentState)
    ST_Read:  begin
      Read = 1'b1;
      Write = 1'b0;
    end //
    ST_Write: begin
      Read = 1'b0;
      Write = 1'b1;
    end
    ST_Delay: begin
      Read = 1'b0;
      Write = 1'b0;
    end
    default : begin
      Read = 1'b0;
      Write = 1'b0;
    end
  endcase

end // always


endmodule

