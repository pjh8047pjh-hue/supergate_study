
`timescale 1ns/10ps

module tb_tx();


//*************************************************************
//Clock & Reset
//**************************************************************
reg clk;
reg reset_n;

integer i;
integer error_count;

parameter clock_freq = 10; // 100 MHz

initial clk = 1'b0;
always #(clock_freq/2) clk = ~clk;

initial begin
  reset_n = 1'b0;
  repeat(10) @(negedge clk);
  reset_n = 1'b1;
end // always

//*************************************************************
//I2C Device Address
//**************************************************************
parameter [6:0] dev_adr = 7'h45;
parameter i2c_freq = 1000;  // 1 us 1MHz

//*************************************************************
//I2C Controls
//**************************************************************
// ctrl0  : [7  ] write (0) or read (1)
//          [6:0] byte length of data (1 ~ 80)
// ctrl1  : [7:0] I2C Speed/Clock Freq
// ctrl2  : [7:0] start address
// start  : run i2c_master_top
// reset_n: negative edge reset

wire done;
reg start;
reg [7:0] ctrl0;
reg [7:0] ctrl1;
reg [7:0] ctrl2;

reg [7:0] nbyte;
reg rw_mode;

wire [639:0] data = {
  8'h1a,8'h8c,8'h97,8'h52,8'h5b,8'h4a,8'hbb,8'h46,8'h95,8'h9d,
  8'h93,8'hd0,8'h49,8'h1a,8'h8c,8'h97,8'hb0,8'h02,8'h37,8'h29,
  8'h5d,8'h1e,8'hf8,8'hfd,8'he0,8'h74,8'h2c,8'hf7,8'h00,8'hdd,
  8'h5c,8'hb2,8'h00,8'h00,8'h00,8'h00,8'h56,8'hc0,8'h2f,8'h12,
  8'h82,8'h24,8'hd3,8'hb8,8'he9,8'h37,8'h67,8'h9f,8'h9d,8'h00,
  8'h10,8'h00,8'h2e,8'h32,8'h02,8'h6b,8'hf2,8'h9d,8'h22,8'hd5,
  8'h30,8'h68,8'hcb,8'h13,8'hc0,8'h14,8'h4d,8'ha5,8'h53,8'h95,
  8'h89,8'had,8'h1c,8'h02,8'hac,8'h3d,8'h00,8'h0a,8'h1e,8'hf1
};

/*
initial begin
  start = 1'b0;
  ctrl0 = 8'h0;
  ctrl1 = i2c_freq/clock_freq;
  ctrl2 = 8'h0;

  rw_mode  = 1'b0; // RW Mode (0: Write, 1: Read)

  repeat(1000) @(negedge clk);

  // Writing 8 bytes to slave address from 1 to 9
  ctrl0 = {1'b0, 7'd8};
  ctrl2 = 8'd1;
  run_i2c_master_top();

 // Read 8 bytes from slave address from 1 to 9
  ctrl0 = {1'b1, 8'd8};
  ctrl2 = 7'd1;
  run_i2c_master_top();

  #(10000);
  $display("Simulation Done .... ");
end // initial
*/
initial begin
  start = 1'b0;
  ctrl0 = 8'h0;
  ctrl1 = i2c_freq/clock_freq;
  ctrl2 = 8'h0;

  rw_mode  = 1'b0; // RW Mode (0: Write, 1: Read)

  repeat(1000) @(negedge clk);

ctrl0 = {1'b0, 7'd8};
ctrl2 = 8'd1;
run_i2c_master_top();

error_count = 0;

for (i = 0; i < 8; i = i + 1) begin
    if (u_slave_model.mem[i+1] !== data[639-i*8 -: 8]) begin
        $display("[WRITE FAIL] addr=%0d expected=%02h actual=%02h",
                 i+1, data[639-i*8 -: 8], u_slave_model.mem[i+1]);
        error_count = error_count + 1;
    end
end

if (error_count == 0) $display("[WRITE PASS] 8 bytes matched");
else                  $display("[WRITE FAIL] %0d errors", error_count);


ctrl0 = {1'b1, 7'd8};
ctrl2 = 8'd1;
run_i2c_master_top();

error_count = 0;

for (i = 0; i < 8; i = i + 1) begin
    if (dut.u_rf.rf[i+1] !== data[639-i*8 -: 8]) begin
        $display("[READ FAIL] addr=%0d expected=%02h actual=%02h",
                 i+1, data[639-i*8 -: 8], dut.u_rf.rf[i+1]);
        error_count = error_count + 1;
    end
end

if (error_count == 0) $display("[READ PASS] 8 bytes matched");
else                  $display("[READ FAIL] %0d errors", error_count);

#(10000);
$finish;
end

task run_i2c_master_top;
begin
  start = 1'b0;
  wait(dut.tx.ctrl.fsm.state == 3'd0);
  repeat(2) @(negedge clk);
  start = 1'b1;
  repeat(1) @(negedge clk);
  start = 1'b0;
  @(posedge done);
end
endtask  // run_i2c_master_top


//**************************************************************
// Tx Data
//**************************************************************
/*
wire [639:0] data = {
  8'h1a,8'h8c,8'h97,8'h52,8'h5b,8'h4a,8'hbb,8'h46,8'h95,8'h9d,
  8'h93,8'hd0,8'h49,8'h1a,8'h8c,8'h97,8'hb0,8'h02,8'h37,8'h29,
  8'h5d,8'h1e,8'hf8,8'hfd,8'he0,8'h74,8'h2c,8'hf7,8'h00,8'hdd,
  8'h5c,8'hb2,8'h00,8'h00,8'h00,8'h00,8'h56,8'hc0,8'h2f,8'h12,
  8'h82,8'h24,8'hd3,8'hb8,8'he9,8'h37,8'h67,8'h9f,8'h9d,8'h00,
  8'h10,8'h00,8'h2e,8'h32,8'h02,8'h6b,8'hf2,8'h9d,8'h22,8'hd5,
  8'h30,8'h68,8'hcb,8'h13,8'hc0,8'h14,8'h4d,8'ha5,8'h53,8'h95,
  8'h89,8'had,8'h1c,8'h02,8'hac,8'h3d,8'h00,8'h0a,8'h1e,8'hf1
};
*/
//**************************************************************
// Design Under Testing:  I2C Master
//**************************************************************
wire scl;
wire sda;
ass_i2c_master dut (
  .clk    (clk    ),
  .rstb   (reset_n),
  .dev_adr(dev_adr),
  .start  (start  ),
  .data   (data   ),
  .ctrl0  (ctrl0  ),
  .ctrl1  (ctrl1  ),
  .ctrl2  (ctrl2  ),
  .done   (done   ),
  .scl    (scl    ),
  .sda    (sda    )
);

pullup(scl);
pullup(sda);


//*************************************************************
//I2 Slave Model
//**************************************************************
i2c_slave_model #(.device_address(dev_adr)) u_slave_model (
.reset_n(reset_n),
.scl    (scl    ),
.sda    (sda    )
);



endmodule