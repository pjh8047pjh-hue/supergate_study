module tb_sig_control;
wire [1:0] wide, narrow;
reg car;
reg clk, rst;

sig_control SC(wide, narrow, car, clk, rst);

initial begin
$monitor($time, "Main Sig = %b Country Sig = %b Car_on_cntry = %b",
wide, narrow, car);
end

initial begin
clk=1'b0;
forever #5 clk = ~clk;
end

initial begin
clk=1'b1;

repeat(5) @(negedge clk);
rst=1'b0;
end

initial begin
car = 1'b0;

repeat(20) @(negedge clk);
car = 1'b1;

repeat(10) @(negedge clk);
car = 1'b0;

repeat(20) @(negedge clk);
car = 1'b1;

repeat(10) @(negedge clk);
car = 1'b0;

repeat(20) @(negedge clk);
car = 1'b1;

repeat(10) @(negedge clk);
car = 1'b0;

repeat(10) @(negedge clk);
$stop;

end
endmodule
