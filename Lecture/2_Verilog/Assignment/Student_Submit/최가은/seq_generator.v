module seq_generator(
    output data_out,
    input reset_n, clk
    );

   parameter a = 0, b = 1, c = 2, d = 3, e = 4, f = 5, g = 6, h = 7, i = 8, j = 9, k = 10;

   reg [3:0] state;
   always@(posedge clk or negedge reset_n)
	    begin
        if (!reset_n)
        state <= a;
        else
	        case (state)
		        a :state<=b;
            	b :state<=c;
            	c :state<=d;
            	d :state<=e;
            	e :state<=f;
            	f :state<=g;
            	g :state<=h;
            	h :state<=i;
            	i :state<=j;
            	j :state<=k;
            	k :state<=k;
	        endcase
	    end

	    assign data_out=state;

endmodule
