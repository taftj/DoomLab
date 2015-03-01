module clock16(slowClock, CLOCK_50, reset);
	input CLOCK_50;
	input reset;
	output reg slowClock;
	initial slowClock = 0;

	reg[8:0] clockFaker;
	initial clockFaker = 0; //count to 326

	always @(posedge CLOCK_50 or negedge reset) begin
		if (!reset) clockFaker = 0;
		else begin 
			if (clockFaker == 326) begin clockFaker = 0; slowClock = 1; end
			else begin clockFaker = clockFaker + 1; slowClock = 0; end
		end
	end
endmodule
