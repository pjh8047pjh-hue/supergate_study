module ass_i2c_slave_serdes_fsm #(
    parameter [6:0] device_address = 7'h45
)(
	input clk,   
	input rstb,  
	input start,
	input stop,
	input scl_rise,
	input scl_fall,	
	input ack_bit,
	input rx_full,
	input tx_empty,

	input [7:0] rx_wdata,
	input [7:0] tx_rdata,
	input [3:0] cnt_scl,
	
	output tx_ren,
	output stop_nack,
	output cnt_inc,
	output cnt_max,
	output init_0,
	output rx_en,
	output rx_wen, 
	output req,
	output reg sda_oe
);

localparam IDLE  = 3'b000;
localparam CHECK = 3'b001; 
localparam START = 3'b010;
localparam READ  = 3'b011;
localparam WRITE = 3'b100;

//=============================================================================
//current state logic 

reg [2:0] cstate;
reg [2:0] nstate;

always @(posedge clk or negedge rstb) begin
	if(!rstb) begin
		cstate <= IDLE;
	end else begin
		cstate <= nstate;
	end
end
//=============================================================================

//=============================================================================
// next state logic
wire addr_match = (rx_wdata[7:1] == device_address);
wire mode       = rx_wdata[0];
wire update_en  = (scl_rise && cnt_max);

always @(*) begin
    nstate = cstate;

    if (stop) begin
        nstate = IDLE;
    end else if (start) begin
        nstate = CHECK;
    end else begin
        case (cstate)
            IDLE    : nstate = IDLE;
			CHECK   : nstate = update_en ? (addr_match ? (mode ? READ : WRITE) : IDLE) : CHECK;
			START   : nstate = update_en ? WRITE : START;
            READ    : nstate = update_en ? (stop_nack ? IDLE : READ) : READ;
            WRITE   : nstate = WRITE;
            default : nstate = IDLE;
        endcase
    end
end
//=============================================================================
reg cnt_en;

//cnt en logic
always @(posedge clk or negedge rstb) begin
    if (!rstb)
        cnt_en <= 1'b0;
    else if (init_0 || (cstate == IDLE))
        cnt_en <= 1'b0;
    else if (scl_fall)
        cnt_en <= 1'b1;
end
//=============================================================================
wire cnt_scl_bit = (cnt_scl == 4'd7);

// output comb logic
// cnt control logic
assign init_0  = start || stop;
assign cnt_max = (cnt_scl == 4'd8);
assign cnt_inc = cnt_en && (cstate != IDLE) && scl_fall;

// rx shift tick signal
assign rx_en = scl_rise && ~cnt_max && ~start &&
              ((cstate == CHECK) ||
               (cstate == START) ||
               (cstate == WRITE));

// ack logic
assign stop_nack = stop || ((cstate == READ) && update_en && ack_bit);

// serdes to pkg decoder logic
assign rx_wen = scl_fall && cnt_scl_bit && 
			 ((cstate == START) || (cstate == WRITE));

assign req = scl_rise && cnt_max && (nstate == READ);

assign tx_ren = (cstate == READ) && scl_fall && cnt_max && !tx_empty;
//=============================================================================

//=============================================================================
// sda_oe logic (Sequential)

always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		sda_oe <= 1'b0;
	end else if (init_0) begin
   		sda_oe <= 1'b0;
	end else if (scl_fall) begin
		case(cstate)
			CHECK  : sda_oe <= cnt_scl_bit && addr_match;
			START  : sda_oe <= cnt_scl_bit;
			READ   : sda_oe <= cnt_max ? ~tx_rdata[7] : ((cnt_scl  < 4'd7) ? ~tx_rdata [6 - cnt_scl] : 1'b0);
			WRITE  : sda_oe <= cnt_scl_bit;
			default: sda_oe <= 1'b0;
		endcase
	end
end
//=============================================================================

endmodule //: ass_i2c_slave_serdes_fsm
