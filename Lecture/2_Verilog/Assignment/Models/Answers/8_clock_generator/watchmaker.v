module watchmaker(new_clk, clk, reset_n);

output new_clk;
input clk, reset_n;

parameter RATIO = 2;

// ---------------------------------------------------------------
// Counter Block
reg [4:0] counter;
always @(posedge clk or negedge reset_n)
begin
    if (~reset_n) begin
        counter <= 5'b0;
    end
    else begin
        counter <= (counter == (RATIO - 1))? 4'b0: (counter + 1'b1);
    end
end // always
wire sel = (counter >= (RATIO/2));


// ---------------------------------------------------------------
// Mux
wire d = (sel)? 1'b1: 1'b0;

// ---------------------------------------------------------------
// D F/F
reg q;
always @(posedge clk, negedge reset_n)
begin
    if (~reset_n) begin
        q <= 1'b0;
    end
    else begin
        q <= d;
    end
end // always

// Output
assign new_clk = q;


endmodule
