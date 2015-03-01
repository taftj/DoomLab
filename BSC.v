module BSC(count, clk_ctrl, clk, enable, reset);

//For the BSC, state 0000 indicates the start of a bit, 0111 indicates the middle, and 1111 indicates the end of the bit. 

output reg count;
output reg clk_ctrl;
input enable, clk, reset;
reg[4:0] counter;
initial counter = 0;

always@ (posedge clk or negedge reset) begin
		
	if(!enable) counter = 0;

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
