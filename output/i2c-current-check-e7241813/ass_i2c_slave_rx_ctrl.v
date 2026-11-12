`timescale 1ns / 1ps

module ass_i2c_slave_rx_ctrl #(
    parameter [6:0] device_address = 7'h45
) (
	input clk,    
	input rstb,
	input scl,
	input sda,

	input [7:0] wdata,
	input [7:0] rdata,

	output reg  sda_d2,
	output reg  sda_oe,
	output wire init_addr,
	output wire rx_en,
	output wire addr_inc,
	output wire read_en,
	output wire we
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
reg sda_d1;
reg scl_d1;
reg scl_d2;
reg cnt_en;
reg [3:0] cnt_scl;

wire start;
wire stop;
wire scl_rise;
wire scl_fall;
wire sda_rise;
wire sda_fall;

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
wire addr_match = (wdata[7:1] == device_address);
wire mode       = wdata[0];
wire ack_input  = sda_d2;

always @(*) begin
    nstate = cstate;

    if (stop) begin
        nstate = IDLE;
    end else if (start) begin
        nstate = CHECK;
    end else begin
        case (cstate)
            IDLE : nstate = IDLE;

            CHECK : begin
                if (scl_rise && cnt_scl == 4'd8)
                    nstate = addr_match ? (mode ? READ : START) : IDLE;
            end

            START : begin
                if (scl_rise && cnt_scl == 4'd8)
                    nstate = WRITE;
            end

            READ  : begin
                if (scl_rise && cnt_scl == 4'd8)
                    nstate = ack_input ? IDLE : READ;
            end

            WRITE : nstate = WRITE;

            default : nstate = IDLE;
        endcase
    end
end
//=============================================================================


//=============================================================================
// edge detecter

 always @(posedge clk or negedge rstb) begin
 	if(~rstb) begin
 		sda_d1 <= 0;
 		sda_d2 <= 0;
 		scl_d1 <= 0;
 		scl_d2 <= 0;
 	end else begin
 		sda_d1 <= sda;
 		sda_d2 <= sda_d1;
 		scl_d1 <= scl;
 		scl_d2 <= scl_d1;
 	end
 end

assign scl_fall = (scl_d2 && !scl_d1);
assign scl_rise = (scl_d1 && !scl_d2);

assign sda_fall = (!sda_d1 && sda_d2);
assign sda_rise = (sda_d1 && !sda_d2);

assign start = scl_d1 && scl_d2 && sda_fall;
assign stop  = scl_d1 && scl_d2 && sda_rise;
//=============================================================================

//=============================================================================
// count scl

always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		cnt_en <= 0;
	end else if(start || stop || nstate == IDLE) begin
		cnt_en <= 1'b0;
	end else if(scl_fall) begin
		cnt_en <= 1'b1;
	end 
end

// cnt_scl
always @(posedge clk or negedge rstb) begin
    if (!rstb) begin
        cnt_scl <= 4'd0;
	end
    else if (start || stop) begin
        cnt_scl <= 4'd0;
	end
    else if (cnt_en && scl_fall) begin
        cnt_scl <= (cnt_scl == 4'd8) ? 4'd0 : cnt_scl + 1'b1;
	end
end
//=============================================================================

//=============================================================================
// output comb logic
assign init_addr  = (cstate == START);
assign read_en    = (cstate == READ);
assign ack_output = (cnt_scl == 8);

assign rx_en = scl_rise && (cnt_scl < 4'd8) &&
               ((cstate == CHECK) ||
                (cstate == START) ||
                (cstate == WRITE));

assign addr_inc = scl_rise && (cnt_scl == 4'd8) &&
                  ((cstate == WRITE) ||
                   (cstate == READ && !ack_input));

assign we = (cstate == WRITE) &&
            scl_fall && (cnt_scl == 4'd7);
//=============================================================================

//=============================================================================
// sda_oe logic (Sequential)
always @(posedge clk or negedge rstb) begin
	if(~rstb) begin
		sda_oe <= 1'b0;
	end else if (start || stop) begin
   		sda_oe <= 1'b0;
	end else if (scl_fall) begin
		case(cstate)
			CHECK  : sda_oe <= (cnt_scl == 4'd7) && addr_match;
			START  : sda_oe <= (cnt_scl == 4'd7);
			READ   : begin
				if (cnt_scl == 4'd8) begin
					sda_oe <= ~rdata[7];
				end
				else if (cnt_scl < 4'd7) begin
					sda_oe <= ~rdata[6 - cnt_scl];
				end
				else begin
					sda_oe <= 1'b0;
				end
			end
			WRITE  : sda_oe <= (cnt_scl == 4'd7);
			default: sda_oe <= 1'b0;
		endcase
	end
end
//=============================================================================

endmodule // : ass_i2c_slave_rx_ctrl   
