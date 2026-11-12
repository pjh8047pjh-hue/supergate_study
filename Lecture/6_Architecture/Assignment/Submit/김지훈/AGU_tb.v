module AGU_tb();

wire [15:0] addr;

reg clk, rst;
reg [15:0] imm, rf;
reg [3:0] op;


AGU_TOP AGU(clk, rst, addr, imm, rf, op);

always #5 clk = ~clk;

initial begin
    clk = 0; rst = 0;
    imm = 0; rf = 0; op = 0;
    $monitor("clk = %1b, op = %4b, addr = %d", clk, op, addr);
    #10 imm = 16'd50; rf = 16'd30; // set AR0
    #20 rst = 1; 
    #10 op = 4'b0001; rf = 16'd3; // set AR1
    #10 op = 4'b0010; rf = 16'd40; // set STEP
    #10 op = 4'b1110; rf = 16'd10; // set BOT
    #10 op = 4'b1111; rf = 16'd75; // set TOP
    #10 op = 4'b0100;
    #10 op = 4'b0101;
    #10 op = 4'b0110;
    #10 op = 4'b0111;
    #10 op = 4'b1000;
    #10 op = 4'b1001;
    #10 op = 4'b1010;
    #100 op = 4'b1011;
    #100 $finish;
end

endmodule
