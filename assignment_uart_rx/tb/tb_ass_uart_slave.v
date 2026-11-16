`timescale 1ns / 10ps

module tb;

//******************************************************************
// Clock & Reset
//******************************************************************
reg [4:0] clk;

localparam CLK_40MHZ  = 4'h0;
localparam CLK_44MHZ  = 4'h1;
localparam CLK_66MHZ  = 4'h2;
localparam CLK_50MHZ  = 4'h3;
localparam CLK_100MHZ = 4'h4; // UART master model clock

task automatic gen_clk_period;
    input [3:0] idx;
    input real period_ns;
    begin
        clk[idx] = 1'b0;
        forever #(period_ns / 2.0) clk[idx] = ~clk[idx];
    end
endtask

task automatic gen_clk_freq;
    input [3:0] idx;
    input real freq_mhz;
    begin
        gen_clk_period(idx, 1000.0 / freq_mhz);
    end
endtask

initial begin
    fork
        gen_clk_freq  (CLK_40MHZ , 40.0);
        gen_clk_freq  (CLK_44MHZ , 44.0);
        gen_clk_freq  (CLK_66MHZ , 66.0);
        gen_clk_freq  (CLK_50MHZ , 50.0);
        gen_clk_freq  (CLK_100MHZ, 100.0);
    join
end

// Change the clock and baud inputs together while reset is asserted.
reg [3:0] clk1_sel = CLK_40MHZ;
wire clk1 = clk[clk1_sel];
wire clk2 = clk[CLK_50MHZ];

reg reset_n;
initial begin
	reset_n = 1'b0;
	repeat(10) @(negedge clk);
	reset_n = 1'b1;
end //

//******************************************************************
// UART Master Model
//******************************************************************
wire ser_in;
wire ser_out;

// Keep these names: uart_packet calls its sibling uart_master.
uart_master uart_master (
    .clk     (clk[CLK_100MHZ]),
    .ser_in  (ser_in),
    .ser_out (ser_out)
);

uart_packet uart_packet (.clk(clk[CLK_100MHZ]));

//******************************************************************
// Run a UART master model
//******************************************************************
parameter [6:0] dev_adr = 7'h5a;
reg [15:0] baud_freq;
reg [15:0] baud_limit;

reg [127:0] read_data;
reg [7:0] rdata;

task print_read_result;
    input [7:0] read_addr;
    input integer read_length;
    integer i;
    reg [7:0] write_data;
    begin
        for (i = 0; i < read_length; i = i + 1) begin
            write_data = uart_packet.mem[8*(read_addr+i) +: 8];
            rdata = read_data[8*(read_length-1-i) +: 8];

            $display("[READ] addr=0x%02h write=0x%02h UART=0x%02h %s",
                     read_addr+i, write_data, rdata,
                     (rdata === write_data) ? "PASS" : "FAIL");
        end
    end
endtask

task run_uart_sequence;
    input integer clk1_mhz;
    input integer clk2_mhz;
    begin
        $display("TEST: clk1=%03dMHz clk2=%03dMHz", clk1_mhz, clk2_mhz);
        $display("BAUD: baud_freq=%0d baud_limit=%0d", baud_freq, baud_limit);
        read_data = 128'b0;

        repeat(200) @(posedge clk1);

        $display("Generating Write Packet...");
        uart_packet.write_packet(dev_adr, 0, 32); // work format

        #10000;

        $display("Generating Read Packet...");
        uart_packet.read_packet(dev_adr, 3, 16, read_data);
        print_read_result(8'd3, 16);

        #100000;
    end
endtask

initial begin
    read_data = 0;
    rdata = 0;
    
    clk1_sel = CLK_40MHZ;
    baud_freq = 16'd144;
    baud_limit = 16'd2981;
    run_uart_sequence(40, 50);

    clk1_sel = CLK_44MHZ;
    baud_freq = 16'd288;
    baud_limit = 16'd6587;
    run_uart_sequence(44, 50);

    clk1_sel = CLK_66MHZ;
    baud_freq = 16'd192;
    baud_limit = 16'd6683;
    run_uart_sequence(66, 50);

    $display("UART test sequences completed.");
    $stop;
end

//******************************************************************
// Design under Testing: UART Slave RTL
//******************************************************************
ass_uart_slave dut (
    .baud_freq  (baud_freq),
    .baud_limit (baud_limit),
    .clk1    (clk1),
    .clk2    (clk2),
    .rstb    (reset_n),
    .ser_in  (ser_in),
    .ser_out (ser_out),
    .dev_adr (dev_adr)
);

endmodule
