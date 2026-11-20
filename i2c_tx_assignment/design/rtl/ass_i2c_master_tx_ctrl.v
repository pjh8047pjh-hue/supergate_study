module ass_i2c_master_tx_ctrl (
    input  wire       clk,
    input  wire       reset_n,
    input  wire       start,
    input  wire       mode,
    input  wire [6:0] length,
    input  wire [7:0] start_addr,
    input  wire       sampling,
    input  wire       shift,
    input  wire       scl_update,
    input  wire [6:0] cnt_byte,
    input  wire [3:0] cnt_bit,

    output wire       rw_bit,
    output wire       we,
    output wire       done,
    output reg  [6:0] addr,
    output reg        sel_sda,
    output reg        sda_out_fsm
);

localparam IDLE     = 3'b000;
localparam START    = 3'b001;
localparam DEV_ADDR = 3'b010;
localparam REG_ADDR = 3'b011;
localparam READ     = 3'b100;
localparam WRITE    = 3'b101;
localparam STOP     = 3'b110;
//=============================================================================
reg [2:0] cstate;
reg [2:0] nstate;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        cstate <= IDLE;
    end
    else begin
        cstate <= nstate;
    end
end
//=============================================================================
always @(*) begin
    nstate = cstate;

    case(cstate)
        IDLE     : nstate = start ? START : IDLE;
        START    : nstate = scl_update ? DEV_ADDR : START;
        DEV_ADDR : nstate =  (cnt_byte == 7'd1) ? REG_ADDR : 
                            ((cnt_byte == 7'd3) ? READ : DEV_ADDR);
        REG_ADDR : nstate = ((cnt_byte == 7'd2) && !mode) ? WRITE :
                            (((cnt_byte == 7'd2) &&  mode) ? START : REG_ADDR);
        READ     : nstate = (cnt_byte - 7'd3 == length) ? STOP : READ;
        WRITE    : nstate = (cnt_byte - 7'd2 == length) ? STOP : WRITE;
        STOP     : nstate = scl_update ? IDLE : STOP;
    endcase
end
//=============================================================================
// sel_sda logic
always @(*) begin
    case(cstate)
        START    : sel_sda = 1'b0;
        DEV_ADDR : sel_sda = (cnt_bit == 4'd8) ? 1'b0 : 1'b1;
        REG_ADDR : sel_sda = (cnt_bit == 4'd8) ? 1'b0 : 1'b1;
        READ     : sel_sda = 1'b0;
        WRITE    : sel_sda = (cnt_bit == 4'd8) ? 1'b0 : 1'b1;
        STOP     : sel_sda = 1'b0;
        default  : sel_sda = 1'b0;
    endcase
end
//=============================================================================
// sda_out_fsm logic
wire last_rd = (cnt_byte - 7'd2 == length);

always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        sda_out_fsm <= 1'b0;
    end else begin
        case(cstate)
            START    : begin
                if (shift) sda_out_fsm <= 1'b0;
                else if (sampling) sda_out_fsm <= 1'b1;
            end
            READ     : begin
                if (shift) sda_out_fsm <= (cnt_bit == 4'd8) ? !last_rd : 1'b0;
            end
            STOP     : begin 
                if (shift) sda_out_fsm <= 1'b1;
                else if (sampling) sda_out_fsm <= 1'b0;
            end
            default  : if (shift) sda_out_fsm <= 1'b0;
        endcase
    end
end
//=============================================================================
// addr
wire addr_inc;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        addr <= 7'd0;
    end
    else if (start) begin
        addr <= start_addr;
    end
    else if (addr_inc) begin
        addr <= addr + 1'b1;
    end
end
//=============================================================================
assign done = (cstate == STOP) && (nstate == IDLE);
assign rw_bit = mode & (cnt_byte == 7'd2);
assign we = (cnt_bit == 4'd8);
assign addr_inc = we;

endmodule
