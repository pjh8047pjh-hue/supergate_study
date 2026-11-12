module watchmaker_tb;

wire quick_clk, slow_clk;
reg clk = 0, reset_n = 1;

watchmaker #(2) quick_watch(quick_clk, clk, reset_n);
watchmaker #(20) slow_watch(slow_clk, clk, reset_n);

always #100 clk = ~clk;  // f = 10 MHz

initial begin
    $monitor($time, "ns 10M-clk: %b, 5M-clk: %b, 500k-clk: %b",
             clk, quick_clk, slow_clk);

    reset_n = 0;
    #5 reset_n = 1;

    #6000 $finish;
end

endmodule


module watchmaker(quick_clk, clk, reset_n);
input clk, reset_n;
output quick_clk;

reg quick_clk = 1'b0;
reg [27:0] counter;

always@(posedge reset_n or posedge clk)
begin
    if (reset_n == 1'b1)
        begin
            quick_clk <= 0;
            counter <= 0;
        end
    else
        begin
            counter <= counter + 1;
            if ( counter == 25_000_000)
                begin
                    counter <= 0;
                    quick_clk <= ~quick_clk;
                end
        end
end
endmodule
 