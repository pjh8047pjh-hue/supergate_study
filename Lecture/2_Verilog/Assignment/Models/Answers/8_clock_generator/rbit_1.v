module rbit_1 #(
    parameter width = 1
)(
    input                  clk,
    input                  reset_n,
    output     [width-1:0] din,
    output reg [width-1:0] dout
);

always @(posedge clk or negedge reset_n)
begin
    if (~reset_n) begin
        dout <= {width{1'b0}};
    end
    else begin
        dout <= din;
    end // always
end // alwyas

endmodule  // rbit_1
