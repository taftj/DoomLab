module RX(DataOut, DataIn, charRX, CLOCK_50, reset);

output reg [7:0] DataOut;
output charRX;
input DataIn, CLOCK_50, reset;

assign charRX = charReceived;

wire Clock16;
wire enable;
wire count;
wire kill;
wire shift;
wire [7:0] shiftedData;
wire charReceived;

initial DataOut = 8'b10111011; //BB

clock16 rxClock16(Clock16, CLOCK_50, reset);
startStop rxEnabler(DataIn, charReceived, reset, enable);
BSC rxBSC(count, shift, Clock16, enable, reset);
BIC rxBIC(charReceived, count, enable, Clock16, kill, reset);
ShiftRegisterIn RXSFR(shiftedData, DataIn,charReceived, shift,CLOCK_50, reset);
charRecKiller rxClear(kill, charReceived, Clock16, reset);
//charRecKiller(kill, charReceived, Clock16, reset);
always @(posedge charReceived or posedge reset) begin
	if (reset) DataOut = 8'b00011000;
	else DataOut = shiftedData;
end

endmodule

module ShiftRegisterIn(OutData, InData, Pout, clk, CLOCK_50, reset);

output reg [7:0] OutData;
input InData, Pout, clk, reset, CLOCK_50;

initial OutData = 8'b11101110;
wire [7:0] X;

//D_FF msb (X[9], X[8], reset, clk);
D_FF nsb (X[7], X[6], reset, clk);
D_FF osb (X[6], X[5], reset, clk);
D_FF psb (X[5], X[4], reset, clk);
D_FF qsb (X[4], X[3], reset, clk);
D_FF rsb (X[3], X[2], reset, clk);
D_FF ssb (X[2], X[1], reset, clk);
D_FF tsb (X[1], X[0], reset, clk);
D_FF usb (X[0], InData, reset, clk);
//D_FF vsb (X[0], InData, reset, clk);

always @(posedge reset or posedge Pout or posedge CLOCK_50) begin
	
	 if(reset) OutData[7:0] = 8'b11101111; 
	 else OutData[7:0] = X[7:0];
	
	//else // EE for testing
	//OutData = 8'b11101110;
end
endmodule
module D_FF (q, d, reset, clk); 
 output q; 
 input d, reset, clk;
 
 reg q; // Indicate that q is stateholding 
 
 always @(posedge clk or posedge reset) 
 if (reset) 
 q = 0; // On reset, set to 0 
 else 
 q = d; // Otherwise out = d 
endmodule 

module startStop(serialIn,charRec,reset,enable);
	
	input serialIn, reset, charRec;
	output reg enable;
	initial enable = 0;
	
	always @(negedge serialIn or posedge reset or negedge charRec) begin
		if (reset) enable = 0;
		else if (!serialIn) enable = 1;
		else if (!charRec) enable = 0;
		else enable = 1;
	end

endmodule
