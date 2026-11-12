module histogram
    (
     input            clk,
                      reset_n,
                      score_ena,
                      get_result,
     input      [7:0] score,
     output reg       rdy,
     output reg [7:0] data
	    );
	wire	[3:0] result_a; 
    reg     [5:0] result[10:0];
	integer i=0;
    assign  result_a = (score<10) ? 0 : 
	          		   (score<20) ? 1 :
			  		   (score<30) ? 2 :
			  		   (score<40) ? 3 :
		      		   (score<50) ? 4 :
				       (score<60) ? 5 :
				       (score<70) ? 6 :
				       (score<80) ? 7 :
				       (score<90) ? 8 :
				       (score<100) ? 9 :
				       (score==100)? 10 : 11;
                   
    always @(posedge clk or negedge reset_n) begin
	    if (!reset_n)begin
		    rdy<=0;
		    i<=0;
		    for (i=0; i<11; i=i+1) result[i] <=0;
	    end
	    else begin
		    if (score_ena)
		        result[result_a]<=result[result_a]+1;
	        if(i<11) begin
		    	if (get_result) begin
			    	rdy <=1;
			    	data<=result[i];
			    	i <= i+1;
		    	end
		    end
		    else rdy<=0;
	    end
    end
endmodule
