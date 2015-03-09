module TX(DataOut, DataIn, Pload, Enable, charReceived, CLOCK_50, reset);

output reg DataOut;
output charReceived;
input [7:0] DataIn;
input Pload, Enable, CLOCK_50, reset;

//wire Enable;
wire Clock16;
wire count;
wire shift;
wire shiftedData;
wire kill;
initial DataOut = 1;
//assign Enable = ~charReceived;

ShiftRegisterOut TXSFR(shiftedData, DataIn, Pload, Enable, shift, reset);
BSC txBSC(count, shift, Clock16, Enable, reset);
BIC txBIC(charReceived, count, Enable, Clock16, kill, reset);
clock16 txClock16 (Clock16, CLOCK_50, reset);
charRecKiller txClear(kill, charReceived, Clock16, reset);

//CuteTestingModule stoatenshire(Enable, Pload, charReceived);

always @(posedge CLOCK_50 or posedge reset) begin
	if(reset) DataOut = 1;
	else if (Enable) DataOut = shiftedData;
	else DataOut = 1;
end

endmodule

/*module CuteTestingModule(enable, Pload, charReceived);
input Pload, charReceived;
output reg enable;
initial enable = 0;
always@ (posedge Pload) begin
	enable = 1;
	end

always @(posedge charReceived) begin
	enable = 0;
	end

endmodule*/

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
 initial q = 0;
 always @(posedge clk or posedge reset or negedge parallelLoad) 
 if (reset) 
 q = 0; // On reset, set to 0 
 else begin
 if (!parallelLoad) q = pl; // Otherwise out = d 
 else q = d;
 end
endmodule
