module voter(indicator, agree);

output indicator;
input [2:0] agree;

wire [2:0] w;

and U0 (w[0], agree[0], agree[1]);
and U1 (w[1], agree[1], agree[2]);
and U2 (w[2], agree[2], agree[0]);

or U3 (indicator, w[0], w[1], w[2]);

endmodule