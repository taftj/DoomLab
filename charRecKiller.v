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
	else counter = 0;	
	end
	
endmodule
