`include "TX.v"

module TXTest;

reg [7:0] DataIn;
reg Pload, Enable, Clock, Reset;

wire DataOut;
wire CharReceived;
parameter delay = 2;
initial Pload = 0;
initial Enable = 0;

initial Reset = 0;
initial Clock = 0;
initial DataIn = 8'b00000000;

initial
begin
repeat(1000000) begin #(delay) Clock = ~Clock; end
end

initial
begin


#delay Reset = 1;

#delay Reset = 0;
#delay Pload = 1;
//Enable = 1;
DataIn = 8'b11001110; 
#(delay*5000) Pload = 0;
#(delay*96000);
//Enable = 0;
#delay DataIn = 8'b11101111;
Pload = 1;
//Enable = 1;
#(delay*5000) Pload = 0;
#(delay*96000); //Enable = 0; 

#delay DataIn = 8'b11011110;
Pload = 1;
//Enable = 1;
#(delay*5000) Pload = 0;
#(delay*96000) //Enable = 0; 
#delay DataIn = 8'b10101101;
Pload = 1;
//Enable = 1;
#(delay*5000) Pload = 0;
#(delay*96000); //Enable = 0; 

#delay DataIn = 8'b10111110;
Pload = 1;
//Enable = 1;
#(delay*5000) Pload = 0;
#(delay*96000) //Enable = 0; 
#delay DataIn = 8'b11101111;
Pload = 1;
//Enable = 1;
#(delay*5000) Pload = 0;
#(delay*96000); //Enable = 0; 

end

TX dut(DataOut, DataIn, Pload, Enable, CharReceived, Clock, Reset);

//ostensible gtkwave stuff
	initial 
		begin
			$dumpfile("DOOM.vcd");
			$dumpvars(1,dut);
			$dumpvars(1,dut.bro1);
		end

endmodule
