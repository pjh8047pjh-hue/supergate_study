module sequence_detector(
    output data_out,
    input data_in, reset_n, clk
    );
    
   parameter a = 0, b = 1, c = 2, d = 3, e = 4;
   
   reg state; 
   always@(posedge clk or negedge reset_n)
	    begin
        if (!reset_n)
        state <= a;    
        else 
	        case (state)
		        a : if (data_in) state<=b;
		        else     		 state<=a;
            	b : if (data_in) state<=c;
            	else     		 state<=a;
            	c : if (data_in) state<=d;
            	else     		 state<=a;
            	d : if (data_in) state<=e;
            	else     		 state<=a;
            	e : if (data_in) state<=e;
            	else 			 state<=a;
	        endcase 
	    end
	    assign data_out=state;
	    
endmodule
