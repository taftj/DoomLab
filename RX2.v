module RX(DataOut, DataIn, CLOCK_50, reset);

output reg [7:0] DataOut;
input DataIn, CLOCK_50, reset;

wire Clock16;
wire enable;
wire count;
wire shift;
wire [7:0] shiftedData;
wire charReceived;

initial DataOut = 8'b11101110;

RX_clock16 bro4 (Clock16, CLOCK_50, reset);
RX_startStop bro5(DataIn, charReceived, reset, enable);
RX_BSC bro2(count, shift, Clock16, enable, reset);
RX_BIC bro3(charReceived, count, enable, Clock16, kill, reset);
RX_ShiftRegisterIn bro1 (shiftedData, DataIn,charReceived, shift,CLOCK_50, reset);
RX_charRecKiller omgWhy(kill, charReceived, Clock16, reset);
//charRecKiller(kill, charReceived, Clock16, reset);
always @* begin
	DataOut = shiftedData;
end

endmodule

module RX_ShiftRegisterIn(OutData, InData, Pout, clk, CLOCK_50, reset);

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

always @(posedge CLOCK_50 or posedge reset or posedge Pout) begin
	
	 if(reset) OutData[7:0] = 8'b11101110; 
	 else if (Pout) OutData[7:0] = X[7:0];
	 else OutData[7:0] = 8'b11101110;
	
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

module RX_BSC(count, clk_ctrl, clk, enable, reset);

//For the BSC, state 0000 indicates the start of a bit, 0111 indicates the middle, and 1111 indicates the end of the bit. 

output reg count;
output reg clk_ctrl;
input enable, clk, reset;
reg[3:0] counter;
initial counter = 0;

always@ (posedge clk or posedge reset or negedge enable) begin
		
	if(!enable) begin counter = 0; count = 0; end
	else begin 
	case(counter) 
	4'b0111: clk_ctrl = 1;
	4'b1111: count = 1;
	default: begin count = 0; clk_ctrl = 0; end
	endcase
	counter = counter + 1;
	end
	end

endmodule

module RX_BIC(charRec, BSCstate, enable, clock16, charDisable, reset);

	output reg charRec;
	input clock16;
	input BSCstate;
	input enable;
	input reset;
	input charDisable;
	
	reg[3:0] counter;
	initial counter = 4'b0;
	initial charRec = 0;
	
	always @(posedge clock16) begin
		if (counter == 9) charRec = 1;
		if (charDisable) charRec = 0;
	end
	//assign charRec = (counter == 9) ? 1 : 0;
	always @(posedge BSCstate or posedge reset or negedge enable) 
	begin
		if (reset) counter = 0;
		else case(enable)
			1: counter = counter + 1;
			0: counter = 0;
		endcase
		
	end
	
endmodule

module RX_clock16(slowClock, CLOCK_50, reset);
	input CLOCK_50;
	input reset;
	output reg slowClock;
	initial slowClock = 0;

	reg[8:0] clockFaker;
	initial clockFaker = 0; //count to 326

	always @(posedge CLOCK_50 or posedge reset) begin
		if (reset) clockFaker = 0;
		else begin 
			if (clockFaker == 300) begin clockFaker = 0; slowClock = 1; end
			else begin clockFaker = clockFaker + 1; slowClock = 0; end
		end
	end
endmodule


module RX_startStop(serialIn,charRec,reset,enable);
	
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
module RX_charRecKiller(kill, charReceived, Clock16, reset);

output reg kill;
input charReceived, Clock16, reset;
reg[3:0] counter;
initial counter = 0;

always @(posedge Clock16 or posedge reset or posedge charReceived) begin

	if(reset) counter = 0;
	else if(charReceived) case(counter)
	7: begin kill = 1; counter = 0; end
	default: begin kill = 0; counter = counter + 1; end
	endcase
	else begin counter = 0;	kill = 0; end
	end
	
endmodule
