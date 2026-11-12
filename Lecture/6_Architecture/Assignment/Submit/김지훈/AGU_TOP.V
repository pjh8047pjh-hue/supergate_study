module AGU_TOP ( clk, rst, ADDR, IMM, RF, OP );

	
	
output [15:0] ADDR;

input [15:0] IMM, RF;
input [3:0] OP;
input clk, rst;

 wire [1:0] C0, C1, C6, C7;
 wire C2, C3, C4, C5;

AGU_CTRL KJH1(C0, C1, C2, C3, C4, C5, C6, C7, OP);

AGU_DATAPATH KJH2(clk, rst, ADDR, IMM, RF, OP, C0, C1, C6, C7, C2, C3, C4, C5);

endmodule
