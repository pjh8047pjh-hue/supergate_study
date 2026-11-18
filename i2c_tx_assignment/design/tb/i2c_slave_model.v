

`timescale 1ns / 1ps

module i2c_slave_model (

reset_n,

scl ,
sda

);

input reset_n;

input scl;
inout sda;

parameter [6:0] device_address = 7'b001_0000;

reg sta;
reg sta_d;
reg sto;
reg sto_d;

reg [7:0] sr;        // 8bit shift register
reg       rw;        // read/write direction
reg [3:0] bit_cnt;   // 3bit downcounter
wire      lsb_bit;   // lsb bit of a byte ransfered
wire      ack_bit;   // ack bit
reg       master_nack;      // 0 - ack,  1 - nack

// start condition detection
wire sta_reset_n = reset_n & (~sta_d);
always @ (negedge sda or negedge sta_reset_n)
	if (~sta_reset_n) sta <= 1'b0;
	else	sta <= scl;

always @ (posedge scl or negedge reset_n)
	if (~reset_n) sta_d <= 1'b0;
	else sta_d <= sta;

// stop condition detection
wire sto_reset_n = reset_n & ~sto_d;
always @ (posedge sda or negedge sto_reset_n)
	if (~sto_reset_n) sto <= 1'b0;
	else	sto <= scl;

always @ (posedge scl or negedge reset_n)
	if (~reset_n) sto_d <= 1'b0;
	else sto_d <= sto;


assign lsb_bit = (bit_cnt == 4'h7) & ~sta;
assign ack_bit = (bit_cnt == 4'h8) & ~sta;

// scl high edge
always @(posedge scl or negedge reset_n)
begin
	if (~reset_n) begin
		bit_cnt <= 4'h0;
		sr <= 8'h0;
		master_nack <= 1'b0;
	end
	else begin
		if (ack_bit | sta) bit_cnt <= 4'h0;
		else bit_cnt <= bit_cnt + 4'b1;

		//if (~ack_bit & ~lsb_bit) sr <= {sr[6:0], sda};
		if (~lsb_bit) sr <= {sr[6:0], sda};
		if ( lsb_bit) master_nack <= sda;
  end
end // always


// state : one hot
parameter [5:0] st_idle        = 6'b000000;
parameter [5:0] st_get_dev_ack = 6'b000010;
parameter [5:0] st_get_adr     = 6'b000100;
parameter [5:0] st_get_adr_ack = 6'b001000;
parameter [5:0] st_data        = 6'b010000;
parameter [5:0] st_data_ack    = 6'b100000;

reg [5:0] state;
reg [7:0] idx;
wire in_read_period;
wire get_trx_data;
wire get_device;

wire [7:0] rdata;
reg  [7:0] txr;
reg  [7:0] rxr;
wire sda_oe;

// state machine working at scl low edge

wire i2c_reset_n = reset_n & ~(sta | sto);

always @(negedge scl or negedge i2c_reset_n)
begin
	if (~i2c_reset_n) begin
		state <= st_idle;
		rw <= 1'b0;
		txr <= 8'h0;
		rxr <= 8'h0;
//		sda_oe <= 1'b0;
	end
	else begin
		// state machine
		case (state)
			st_idle       : state <= (get_device)? st_get_dev_ack: st_idle;
			st_get_dev_ack: state <= (rw)? st_data: st_get_adr;
			st_get_adr    : state <= (lsb_bit)? st_get_adr_ack: st_get_adr;
			st_get_adr_ack: state <= st_data;
			st_data       : state <= (lsb_bit)? st_data_ack: st_data;
			st_data_ack   : state <= (rw & master_nack)? st_idle: st_data;
			default       : state <= st_idle;
		endcase
/*
		sda_oe <= (state == st_idle & get_device   ) | // ack = 0
		          (state == st_get_adr & lsb_bit   ) | // ack = 0
		          (state == st_data & lsb_bit & ~rw) | // ack = 0
		          (in_read_trx_nxt & ~sdo[7]       );	 // tx to master
*/
		if ((state == st_idle) & get_device) rw <= sr[0];

		if (get_trx_data       ) txr <= rdata;
		else if (in_read_period) txr <= {txr[6:0], 1'b0};

		if (state == st_data & lsb_bit) rxr <= sr;

	end
end // always

assign in_read_period = (rw & state == st_data);

assign sda_oe = (state == st_get_dev_ack     ) | // ack = 0
                (state == st_get_adr_ack     ) | // ack = 0
                (state == st_data_ack  & ~rw ) | // write: ack = 0, read: sda open for master
                (in_read_period & ~txr[7]    ) ; // data transfer to master

assign get_trx_data  = (state == st_get_dev_ack) | (rw & state == st_data_ack);
assign get_device = (sr[7:1] == device_address) & lsb_bit;

wire get_idx;
wire inc_idx;

always @(negedge scl or negedge reset_n)
begin
	if (~reset_n) begin
		idx <= 8'h0;
	end
	else begin
		if (get_idx) idx <= sr[7:0];
		else if (inc_idx) idx <= idx + 1'b1;
	end
end // always

assign get_idx = (state == st_get_adr_ack);
assign inc_idx = (~rw & (state == st_data_ack)) | (rw & (state == st_data) & lsb_bit);

// generate tri-states
assign sda = sda_oe ? 1'b0 : 1'bz;

wire strobe = (state == st_data_ack) & ~rw;
wire [7:0] addr   = idx;
wire [7:0] wdata  = rxr ;

// -- debug

reg [7:0] mem[0:15];

always @(posedge scl) begin
	if (strobe) begin
		mem[addr] = wdata;
		$display("Writing data %01x at addr %d.", wdata, addr);
	end
end // always

assign rdata = mem[addr];

always @(posedge scl) begin
	if ((state == st_data_ack) & rw & ~master_nack) begin
		$display("Read data %01x at addr %d.", wdata, addr);
	end
end // always

reg [255:0] slave_state_ascii;

always @( state)
begin

	case (state)
		st_idle        : begin slave_state_ascii = "st_idle        "; end
		st_get_dev_ack : begin slave_state_ascii = "st_get_dev_ack "; end
		st_get_adr     : begin slave_state_ascii = "st_get_adr     "; end
		st_get_adr_ack : begin slave_state_ascii = "st_get_adr_ack "; end
		st_data        : begin slave_state_ascii = "st_data        "; end
		st_data_ack    : begin slave_state_ascii = "st_data_ack    "; end
	endcase

end //


endmodule


