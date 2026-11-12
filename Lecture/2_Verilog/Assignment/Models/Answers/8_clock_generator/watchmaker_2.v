module watchmaker(new_clk, clk, reset_n);

output new_clk;
input clk, reset_n;

parameter RATIO = 2;

// ---------------------------------------------------------------
// Counter Block
wire [4:0] counter;
wire [4:0] counter_next = (counter == (RATIO - 1))? 4'b0: (counter + 1'b1);
rbit_1 #(5) u_counter (.clk(clk), .reset_n(reset_n), .din(counter_next), .dout(counter));

// ---------------------------------------------------------------
// Mux
wire d = (counter >= (RATIO/2))? 1'b1: 1'b0;

// ---------------------------------------------------------------
// D F/F
rbit_1 #(1) u_dff (.clk(clk), .reset_n(reset_n), .din(d), .dout(new_clk));

endmodule

