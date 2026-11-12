
module graduate_judger(eligible_to_graduate, pass);

input [3:0] pass;
output eligible_to_graduate;

wire [1:0] w;

nand U0 (w[0], pass[0], pass[1], pass[3]);
nand U1 (w[1], pass[2], pass[3]);
nand U2 (eligible_to_graduate, w[0], w[1]);

endmodule