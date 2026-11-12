module voter(
  input [2:0] agree,
  output      indicator
);

assign indicator = (agree[0] & agree[1] |
                    agree[1] & agree[2] |
                    agree[0] & agree[2]);
endmodule
