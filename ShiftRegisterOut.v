module ShiftRegisterOut(OutData, InData, Pload, clk, reset);

output reg OutData;
input [7:0] InData;
input Pload, clk, reset;

wire [9:0] X;
initial OutData = 1;

D_FF_P msb (X[9], X[8], 1, Pload, reset, clk);
D_FF_P nsb (X[8], X[7], InData[7], Pload, reset, clk);
D_FF_P osb (X[7], X[6], InData[6], Pload, reset, clk);
D_FF_P psb (X[6], X[5], InData[5], Pload, reset, clk);
D_FF_P qsb (X[5], X[4], InData[4], Pload, reset, clk);
D_FF_P rsb (X[4], X[3], InData[3], Pload, reset, clk);
D_FF_P ssb (X[3], X[2], InData[2], Pload, reset, clk);
D_FF_P tsb (X[2], X[1], InData[1], Pload, reset, clk);
D_FF_P usb (X[1], X[0], InData[0], Pload, reset, clk);
D_FF_P vsb (X[0], 1, 1, Pload, reset, clk);

always @* begin
	OutData = X[9];
	
end

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
