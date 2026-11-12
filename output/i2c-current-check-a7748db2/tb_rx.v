
`timescale 1ns / 1ps

module tb_rx ();

//******************************************************************
// Clock & Reset
//******************************************************************

reg clk;
reg reset_n;

initial clk = 0;
always #5 clk = ~clk;

initial begin
	reset_n = 1'b0;
	repeat(10) @(negedge clk);
	reset_n = 1'b1;
end //


//******************************************************************
// I2C Master Model
//******************************************************************
i2c_master_top u_i2c_master_top (
  .clk     (clk    ),
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
initial begin
	#50; // mem[10] = 8'h15, mem[11] = 8'h0b

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
    $display("READ_RESULT=%h", rdata);
	u_i2c_master_top.stop (8'h00, 1'b1, 1'b1, rdata); // (read data, nack and stop)
    $display("READ_RESULT=%h", rdata);

	
	u_i2c_master_top.start({dev_adr, 1'b1}         ); // (start with read)
	u_i2c_master_top.byte (8'h00, 1'b1, 1'b0, rdata); // (read data and ack )
    $display("READ_RESULT=%h", rdata);
	u_i2c_master_top.stop (8'h00, 1'b1, 1'b1, rdata); // (read data, nack and stop)
    $display("READ_RESULT=%h", rdata);

	// write again ...
	u_i2c_master_top.start({dev_adr, 1'b0}        );  // (start with write)
	u_i2c_master_top.byte (8'h02, 1'b0, 1'b0, rxr );  // (write addr   )
	u_i2c_master_top.byte (8'h55, 1'b0, 1'b0, rxr );  // (write data      )
	u_i2c_master_top.stop (8'haa, 1'b0, 1'b0, rxr );  // (write data and stop  )

	#(100000)
	u_i2c_master_top.start({dev_adr, 1'b0}        );  // (start with write)
	u_i2c_master_top.byte (8'h05, 1'b0, 1'b0, rxr );  // (write addr   )
	u_i2c_master_top.byte (8'h66, 1'b0, 1'b0, rxr );  // (write data      )
	u_i2c_master_top.stop (8'hbb, 1'b0, 1'b0, rxr );  // (write data and stop  )

	#(100000);
    $stop;
end //


//******************************************************************
// Desing under Testing:  I2C Slave RTL
//******************************************************************
ass_i2c_slave #(.device_address(dev_adr)) dut (

.clk  (clk    ),
.rstb (reset_n),

.scl  (scl    ),
.sda  (sda    )
);



reg hold_valid = 1'b0;
reg previous_read_en;
reg [7:0] previous_rdata;
integer write_hold_checks = 0;
always @(negedge clk) begin
    if (!reset_n) begin
        hold_valid <= 1'b0;
        if (dut.rdata !== 8'h00) begin
            $display("RDATA_RESET_FAIL");
            $finish;
        end
    end else begin
        if (hold_valid && !previous_read_en) begin
            if (dut.rdata !== previous_rdata) begin
                $display("RDATA_HOLD_FAIL: old=%h new=%h", previous_rdata, dut.rdata);
                $finish;
            end
            if (dut.u_rx.u_ctrl.cstate == 3'd4)
                write_hold_checks = write_hold_checks + 1;
        end
        hold_valid <= 1'b1;
        previous_read_en <= dut.read_en;
        previous_rdata <= dut.rdata;
    end
end

endmodule
