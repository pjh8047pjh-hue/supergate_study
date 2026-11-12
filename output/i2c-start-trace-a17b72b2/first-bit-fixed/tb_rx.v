
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
	u_i2c_master_top.byte (8'h00, 1'b1, 1'b0, rdata); // (read data and ack )
	//u_i2c_master_top.stop (8'h00, 1'b1, 1'b0, rdata); // (read data and nack)

	
	u_i2c_master_top.start({dev_adr, 1'b1}         ); // (start with read)
	u_i2c_master_top.byte (8'h00, 1'b1, 1'b0, rdata); // (read data and ack )
	u_i2c_master_top.byte (8'h00, 1'b1, 1'b0, rdata); // (read data and ack )
	//u_i2c_master_top.stop (8'h00, 1'b1, 1'b0, rdata); // (read data and nack)

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



always @(posedge clk) begin
    if (reset_n && dut.u_rx.u_ctrl.start)
        $display("TRACE_START: state=%d cnt=%d oe=%b addr=%h rdata=%h", dut.u_rx.u_ctrl.cstate, dut.u_rx.u_ctrl.cnt_scl, dut.sda_oe, dut.addr, dut.rdata);
    if (reset_n && dut.u_rx.u_ctrl.cstate == 3'd3 && dut.u_rx.u_ctrl.scl_rise && dut.u_rx.u_ctrl.cnt_scl == 4'd8)
        $display("TRACE_READ_ACK: ack_input=%b addr=%h", dut.u_rx.u_ctrl.ack_input, dut.addr);
    if (reset_n && dut.u_rx.u_ctrl.cstate == 3'd3 && dut.u_rx.u_ctrl.scl_fall && dut.u_rx.u_ctrl.cnt_scl == 4'd8)
        $strobe("TRACE_FIRST_BIT: rdata=%h oe=%b sda=%b", dut.rdata, dut.sda_oe, sda);
end

endmodule
