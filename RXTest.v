`include "RX.v"

module RXTest;

reg DataIn, Clock, Reset;

wire [7:0] DataOut;

parameter delay = 2;
initial Reset = 0;
initial Clock = 0;
initial DataIn = 1;

initial
begin
repeat(200000) begin #(delay) Clock = ~Clock; end
end

initial
begin


#delay Reset = 1;

#delay Reset = 0;
#(delay*9600) DataIn = 0;
#(delay*9600) DataIn = 1;
#(delay*9600) DataIn = 0;
#(delay*9600) DataIn = 1;
#(delay*9600) DataIn = 0;
#(delay*9600) DataIn = 1;
#(delay*9600) DataIn = 0;
#(delay*9600) DataIn = 1;
#(delay*9600) DataIn = 0;
#(delay*9600) DataIn = 1;

#(delay*9600) DataIn = 0;
#(delay*9600) DataIn = 1;
#(delay*9600) DataIn = 0;
#(delay*9600) DataIn = 1;
#(delay*9600) DataIn = 0;
#(delay*9600) DataIn = 1;
#(delay*9600) DataIn = 0;
#(delay*9600) DataIn = 1;
#(delay*9600) DataIn = 0;
#(delay*9600) DataIn = 1;




end

RX dut(DataOut, DataIn, Clock, Reset);

//ostensible gtkwave stuff
	initial 
		begin
			$dumpfile("DOOM.vcd");
			$dumpvars(1,dut);
			$dumpvars(1,dut.bro1);
		end

endmodule
