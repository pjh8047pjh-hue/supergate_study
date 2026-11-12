
`timescale 1ns / 1ps

module tb_rx ();

//******************************************************************
// Clock & Reset
//******************************************************************
reg [4:0] clk;

wire clk_10mhz    = clk[0];
wire clk_20mhz    = clk[1];
wire clk_33mhz    = clk[2];
wire clk_50mhz    = clk[3];
wire clk_100mhz   = clk[4];

task automatic gen_clk_period;
    input integer idx;
    input real    period_ns;

    begin
        clk[idx] = 1'b0;
        forever #(period_ns / 2.0) clk[idx] = ~clk[idx];
    end
endtask

task automatic gen_clk_freq;
    input integer idx;
    input real    freq_mhz;

    begin
        gen_clk_period(idx, 1000.0 / freq_mhz);
    end
endtask

initial begin
    fork
        gen_clk_freq  (0, 10.0); 
        gen_clk_freq  (1, 200.0); 
        gen_clk_period(2, 30.0); 
        gen_clk_freq  (3, 50.0); 
        gen_clk_freq  (4, 100.0); 
    join
end

reg reset_n;
initial begin
	reset_n = 1'b0;
	repeat(10) @(negedge clk);
	reset_n = 1'b1;
end //


//******************************************************************
// I2C Master Model
//******************************************************************
i2c_master_top u_i2c_master_top (
  .clk     (clk_100mhz    ),
  .reset_n (reset_n),
  .scl     (scl    ),
  .sda     (sda    )
);

pullup(sda);
pullup(scl);


//******************************************************************
// Run an I2C master model
//******************************************************************
parameter [6:0] dev_adr = 7'h74;

reg [7:0] rxr;
reg [7:0] rdata;

task print_read_result;
    input [6:0] read_addr;
    input [7:0] write_data;
    begin
        $display("[READ] addr=0x%02h write=0x%02h SDA=0x%02h %s",
                 read_addr, write_data, rdata,
                 (rdata === write_data) ? "PASS" : "FAIL");
    end
endtask

task run_i2c_sequence;
	begin
		// Write Data
		u_i2c_master_top.start({dev_adr, 1'b0}         ); // (start with write)
		u_i2c_master_top.byte (8'h0a, 1'b0, 1'b0, rxr  ); // (write addr)
		u_i2c_master_top.byte (8'hf5, 1'b0, 1'b0, rxr  ); // (write data)
		u_i2c_master_top.byte (8'hfb, 1'b0, 1'b0, rxr  ); // (write data)
		u_i2c_master_top.byte (8'h77, 1'b0, 1'b0, rxr  ); // (write data)
		u_i2c_master_top.stop (8'h88, 1'b0, 1'b0, rxr  ); // (write data and stop)

		#50;  // Set start address to read as 0xA
		u_i2c_master_top.start({dev_adr, 1'b0}         );  // (start with write)
		u_i2c_master_top.stop (8'h0a, 1'b0, 1'b0, rxr  );  // (write addr and stop)

		// Read Data
		u_i2c_master_top.start({dev_adr, 1'b1}         ); // (start with read)
		u_i2c_master_top.byte (8'h00, 1'b1, 1'b0, rdata); // (read data and ack )
		print_read_result(7'h0a, 8'hf5);
		u_i2c_master_top.byte (8'h00, 1'b1, 1'b1, rdata); // (read data and nack )
		print_read_result(7'h0b, 8'hfb);
		//u_i2c_master_top.stop (8'h00, 1'b1, 1'b0, rdata); // (read data and nack)
	
		// Read Data (Repeated start)
		u_i2c_master_top.start({dev_adr, 1'b1}         ); // (start with read)
		u_i2c_master_top.byte (8'h00, 1'b1, 1'b0, rdata); // (read data and ack )
		print_read_result(7'h0c, 8'h77);
		u_i2c_master_top.byte (8'h00, 1'b1, 1'b1, rdata); // (read data and nack )
		print_read_result(7'h0d, 8'h88);
		//u_i2c_master_top.stop (8'h00, 1'b1, 1'b0, rdata); // (read data and nack)

		// write again ...
		u_i2c_master_top.start({(dev_adr+7'd1), 1'b0}        );  // (start with write)
		u_i2c_master_top.byte (8'h02, 1'b0, 1'b0, rxr );  // (write addr   )
		u_i2c_master_top.byte (8'h55, 1'b0, 1'b0, rxr );  // (write data      )
		u_i2c_master_top.stop (8'haa, 1'b0, 1'b0, rxr );  // (write data and stop  )

		#(10000)
		u_i2c_master_top.start({dev_adr, 1'b0}        );  // (start with write)
		u_i2c_master_top.byte (8'h05, 1'b0, 1'b0, rxr );  // (write addr   )
		u_i2c_master_top.byte (8'h66, 1'b0, 1'b0, rxr );  // (write data      )
		u_i2c_master_top.stop (8'hbb, 1'b0, 1'b0, rxr );  // (write data and stop  )

		#(100000);
	end
endtask

initial begin
	#50; // mem[10] = 8'h15, mem[11] = 8'h0b

	run_i2c_sequence;

    $stop;
end //


//******************************************************************
// Desing under Testing:  I2C Slave RTL
//******************************************************************
ass_i2c_slave #(.device_address(dev_adr)) dut (

.clk_1  (clk_33mhz    ),
.clk_2  (clk_100mhz    ),
.rstb (reset_n),

.scl  (scl    ),
.sda  (sda    )
);


endmodule
