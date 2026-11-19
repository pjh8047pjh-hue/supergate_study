module ass_i2c_master_tx_ctrl (
    input  wire       clk
    input  wire       reset_n,
    input  wire       start,
    input  reg        mode,
    input  reg  [6:0] length,
    input  reg  [7:0] freq_i2c,
    input  reg  [7:0] start_addr,

    output wire       we,
    output wire       done,
    output wire       addr_inc,
    output wire [6:0] addr,
);

localparam IDLE     = 3'b000;
localparam START    = 3'b001;
localparam DEV_ADDR = 3'b010;
localparam REG_ADDR = 3'b011;
localparam READ     = 3'b100;
localparam WRITE    = 3'b101;
localparam STOP     = 3'b110;

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

always @(*) begin
    nstate = cstate;

    case(cstate)
        IDLE     :
        START    :
        DEV_ADDR :
        REG_ADDR :
        READ     :
        WRITE    :
        STOP     :
    endcase


endmodule