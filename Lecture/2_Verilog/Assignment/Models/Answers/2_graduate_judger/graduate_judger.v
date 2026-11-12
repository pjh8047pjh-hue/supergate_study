module graduate_judger(eligible_to_graduate, pass);

output eligible_to_graduate;
input [3:0] pass;

// code 1
wire n1 = ~(pass[0] & pass[1] & pass[3]);
wire n2 = ~(pass[2] & pass[3]);
assign eligible_to_graduate = ~(n1 & n2);

// Code 2 : easy interpretation
//wire n1 = (pass[0] & pass[1] & pass[3]);
//wire n2 = (pass[2] & pass[3]);
//assign eligible_to_graduate = (n1 | n2);

// Code 3: Optimized
//assign eligible_to_graduate = (pass[0] | pass[1] & pass[2]) & pass[3];


endmodule
