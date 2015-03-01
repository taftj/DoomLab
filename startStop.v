module startStop(serialIn,charRec,reset,enable);
	
	input serialIn, reset, charRec;
	output reg enable;
	initial enable = 0;
	
	always @(negedge serialIn or negedge reset or posedge charRec) begin
		if (!reset) enable = 0;
		else if (!charRec) enable = 1;
		else enable = 0;
	end

endmodule
	
		
		
	
	
	
	
