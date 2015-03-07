module TX(DataOut, DataIn, Pload, enable, charReceived, CLOCK_50, reset);

output reg DataOut;
output charReceived;
input [7:0] DataIn;
input Pload, enable, CLOCK_50, reset;

wire Enable;
wire Clock16;
wire count;
wire shift;
wire shiftedData;
wire kill;
initial DataOut = 1;
//assign Enable = ~charReceived;

ShiftRegisterOut bro1 (shiftedData, DataIn, Pload, Enable, shift, reset);
BSC bro2 (count, shift, Clock16, Enable, reset);
BIC bro3 (charReceived, count, Enable, Clock16, kill, reset);
clock16 bro4 (Clock16, CLOCK_50, reset);
charRecKiller omgWhy(kill, charReceived, Clock16, reset);

CuteTestingModule stoatenshire(Enable, Pload, charReceived);

always @(posedge CLOCK_50 or posedge reset) begin
	if(reset) DataOut = 1;
	else if (Enable) DataOut = shiftedData;
	else DataOut = 1;
end

endmodule

module CuteTestingModule(enable, Pload, charReceived);
input Pload, charReceived;
output reg enable;
initial enable = 0;
always@ (posedge Pload) begin
	enable = 1;
	end

always @(posedge charReceived) begin
	enable = 0;
	end

endmodule

module ShiftRegisterOut(OutData, InData, Pload,enable, clk, reset);

output OutData;
input [7:0] InData;
input Pload, clk, reset, enable;

wire [9:0] X;
assign OutData = X[9];
//initial OutData = 1;

D_FF_P msb (X[9], X[8], 0, Pload, reset, clk);
D_FF_P nsb (X[8], X[7], InData[7], Pload, reset, clk);
D_FF_P osb (X[7], X[6], InData[6], Pload, reset, clk);
D_FF_P psb (X[6], X[5], InData[5], Pload, reset, clk);
D_FF_P qsb (X[5], X[4], InData[4], Pload, reset, clk);
D_FF_P rsb (X[4], X[3], InData[3], Pload, reset, clk);
D_FF_P ssb (X[3], X[2], InData[2], Pload, reset, clk);
D_FF_P tsb (X[2], X[1], InData[1], Pload, reset, clk);
D_FF_P usb (X[1], X[0], InData[0], Pload, reset, clk);
D_FF_P vsb (X[0], 1, 1, Pload, reset, clk);


/*always @* begin
if (enable) OutData = X[9];
else OutData = 1;
end*/

endmodule

module D_FF_P(q, d, pl, parallelLoad, reset, clk); 
 output q; 
 input d, reset, clk;
 input pl, parallelLoad;
 
 reg q; // Indicate that q is stateholding 
 
 always @(posedge clk or posedge reset) 
 if (reset) 
 q = 0; // On reset, set to 0 
 else begin
 
 if (!parallelLoad) q = d; // Otherwise out = d 
 else q = pl;
 
 end
endmodule

module BSC(count, clk_ctrl, clk, enable, reset);

//For the BSC, state 0000 indicates the start of a bit, 0111 indicates the middle, and 1111 indicates the end of the bit. 

output reg count;
output reg clk_ctrl;
input enable, clk, reset;
reg[3:0] counter;
initial counter = 0;

always@ (posedge clk or posedge reset or negedge enable) begin
	if (reset) begin counter = 0; count = 0; end	
	else if(!enable) begin counter = 0; count = 0; end
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

module BIC(charRec, BSCstate, enable, clock16, charDisable, reset);

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

module clock16(slowClock, CLOCK_50, reset);
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

module charRecKiller(kill, charReceived, Clock16, reset);

output reg kill;
input charReceived, Clock16, reset;
reg[3:0] counter;
initial counter = 0;

always @(posedge Clock16 or posedge reset) begin

	if(reset) counter = 0;
	else if(charReceived) case(counter)
	7: begin kill = 1; counter = 0; end
	default: begin kill = 0; counter = counter + 1; end
	endcase
	else begin counter = 0;	kill = 0; end
	end
	
endmodule
