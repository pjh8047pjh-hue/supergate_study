module blake_rtl_state_mux (
	input 		[   6:0] counter,
	input 		[1023:0] state,
	
	output reg  [  63:0] a,b,c,d,
	output reg  [   3:0] sel_a, sel_b, sel_c, sel_d
);


//------------ select logic ----------------
wire [2:0] cnt_g;
wire [3:0] cnt_round;

assign cnt_g     = counter[2:0];
assign cnt_round = counter[6:3];

always @(*) begin
    case (cnt_g)
        // Column
        3'd0:    {sel_a, sel_b, sel_c, sel_d} = {4'd0, 4'd4, 4'd8,  4'd12};
        3'd1:    {sel_a, sel_b, sel_c, sel_d} = {4'd1, 4'd5, 4'd9,  4'd13};
        3'd2:    {sel_a, sel_b, sel_c, sel_d} = {4'd2, 4'd6, 4'd10, 4'd14};
        3'd3:    {sel_a, sel_b, sel_c, sel_d} = {4'd3, 4'd7, 4'd11, 4'd15};

        // Diagonal
        3'd4:    {sel_a, sel_b, sel_c, sel_d} = {4'd0, 4'd5, 4'd10, 4'd15};
        3'd5:    {sel_a, sel_b, sel_c, sel_d} = {4'd1, 4'd6, 4'd11, 4'd12};
        3'd6:    {sel_a, sel_b, sel_c, sel_d} = {4'd2, 4'd7, 4'd8,  4'd13};
        3'd7:    {sel_a, sel_b, sel_c, sel_d} = {4'd3, 4'd4, 4'd9,  4'd14};

        default: {sel_a, sel_b, sel_c, sel_d} = 16'd0;
    endcase
end

//----------- select a, b, c, d -------------
always @(*) begin
    case (sel_a)
        4'd0:    a = state[1023:960];
        4'd1:    a = state[ 959:896];
        4'd2:    a = state[ 895:832];
        4'd3:    a = state[ 831:768];
        default: a = 64'd0;
    endcase
end

always @(*) begin
    case (sel_b)
        4'd4:    b = state[767:704];
        4'd5:    b = state[703:640];
        4'd6:    b = state[639:576];
        4'd7:    b = state[575:512];
        default: b = 64'd0;
    endcase
end

always @(*) begin
    case (sel_c)
        4'd8 :   c = state[511:448];
        4'd9 :   c = state[447:384];
        4'd10:   c = state[383:320];
        4'd11:   c = state[319:256];
        default: c = 64'd0;
    endcase
end

always @(*) begin
    case (sel_d)
        4'd12:   d = state[255:192];
        4'd13:   d = state[191:128];
        4'd14:   d = state[127: 64];
        4'd15:   d = state[ 63:  0];
        default: d = 64'd0;
    endcase
end
endmodule //: state_mux
