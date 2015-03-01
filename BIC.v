module BIC(charRec, BSCstate, enable, reset);

	output charRec;
	input BSCstate;
	input enable;
	input reset;
	
	reg[3:0] counter;
	initial counter = 4'b0;
	
	assign charRec = (counter == 9) ? 1'b1 : 1'bz;
	
	always @(posedge BSCstate or posedge reset or negedge enable) 
	begin
		if (reset) counter = 0;
		else case(enable)
			1: counter = counter + 1;
			0: counter = 0;
		endcase
	end
	
endmodule
