module ShiftRegisterIn(FullData, NewData, Pout, clk, reset);

output reg [7:0] FullData;
input NewData, Pout, clk, reset;

initial FullData = 8'bz;
wire [9:0] X;

D_FF msb (X[9], X[8], reset, clk);
D_FF nsb (X[8], X[7], reset, clk);
D_FF osb (X[7], X[6], reset, clk);
D_FF psb (X[6], X[5], reset, clk);
D_FF qsb (X[5], X[4], reset, clk);
D_FF rsb (X[4], X[3], reset, clk);
D_FF ssb (X[3], X[2], reset, clk);
D_FF tsb (X[2], X[1], reset, clk);
D_FF usb (X[1], X[0], reset, clk);
D_FF vsb (X[0], NewData, reset, clk);

always @* begin

	if(Pout)
	FullData = X[8:1];
	else
	FullData = 8'bz;
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
