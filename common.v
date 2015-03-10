
/*BSC_clockCom
inputs: clock  (clock16, controls counter)
		  enable (whether TX/RX module is to be used)
		  reset  (master reset for system)
output: this one counts the number of bits read/sent
*/
module BSC_clockCom(commander, clock, enable, reset);
input clock, enable, reset;
output reg commander;
reg [3:0] counter;
initial counter = 4'b1000;
initial commander = 1'b0;

always@ (posedge clock or posedge reset or negedge enable) begin
	if (reset) begin counter = 4'b1000; commander = 1'b0; end	 //OMG we did not even use reset
	else if(!enable) begin counter = 4'b1000; commander = 1'b0; end
	else begin 
		case(counter) 
		4'b0111: begin commander = 1'b1; counter = counter + 4'b1; end
		default: begin commander = 1'b0; counter = counter + 4'b1; end
		endcase
	end
end

endmodule

/*BSC_sampler
inputs: clock  (clock16, controls counter)
		  enable (whether TX/RX module is to be used)
		  reset  (master reset for system)
output: whether or not to sample the 1-bit I/O bus
*/
module BSC_sampler(commander, clock, enable, reset);
input clock, enable, reset;
output reg commander;
reg [3:0] counter;
initial counter = 4'b0;
initial commander = 1'b0;

always@ (posedge clock or posedge reset or negedge enable) begin
	if (reset) begin counter = 4'b0; /*commander = 1'b0;*/ end	 //OMG we did not even use reset
	else if(!enable) begin counter = 4'b0; /*commander = 1'b0;*/ end
	else begin 
		case(counter) 
		4'b1111: begin commander = 1'b1; counter = counter + 4'b1; end
		default: begin commander = 1'b0; counter = counter + 4'b1; end
		endcase
	end
end

endmodule



/*module BSC(count, clk_ctrl, clk, enable, reset);

//For the BSC, state 0000 indicates the start of a bit, 0111 indicates the middle, and 1111 indicates the end of the bit. 

output reg count;
output reg clk_ctrl;
input enable, clk, reset;

//reg[3:0] tomSux;
//initial tomSux = 4'b1001;


reg[3:0] counter;
initial counter = 4'b0;
initial count = 1'b0;
initial clk_ctrl = 1'b0;

always@ (posedge clk or posedge reset or negedge enable) begin
	if (reset) begin counter = 4'b0; count = 1'b0; end	 //OMG we did not even use reset
	else if(!enable) begin counter = 4'b0; count = 1'b0; end
	else begin 
		case(counter) 
		4'b0111: begin clk_ctrl = 1'b1; counter = counter + 4'b1; end
		4'b1111: begin count = 1'b1; counter = counter + 4'b1; end
		default: begin count = 1'b0; clk_ctrl = 1'b0; counter = counter + 4'b1; end
		endcase
	end
end

endmodule*/
module BIC(charRec, BSCstate, enable, clock16, charDisable, reset);

	output reg charRec;
	input clock16;
	input BSCstate;
	input enable;
	input reset;
	input charDisable;
	
	reg[3:0] counter;
	initial counter = 4'b0;
	initial charRec = 1'b0;
	
	always @(posedge BSCstate or posedge reset or posedge charDisable) begin
		if (reset) begin counter = 0; end
		else if (charDisable) begin counter = 0; charRec = 0; end
		else case (counter)
			//4'b1001: begin charRec = 1'b0; counter = 0; end
			4'b1000: begin charRec = 1'b1; counter = counter + 1'b1; end
			default: begin counter = counter + 4'b1; end
		endcase
	end
endmodule

module clock16(slowClock, CLOCK_50, reset);
	input CLOCK_50;
	input reset;
	output reg slowClock;
	initial slowClock = 0;

	reg[8:0] clockFaker;
	initial clockFaker = 9'b0; //count to 326

	always @(posedge CLOCK_50 or posedge reset) begin
		if (reset) clockFaker = 0;
		else begin 
			if (clockFaker == 326) begin clockFaker = 9'b0; slowClock = 1'b1; end
			else begin clockFaker = clockFaker + 9'b1; slowClock = 1'b0; end
		end
	end
endmodule

module charRecKiller(kill, charReceived, Clock16, reset);

output reg kill;
input charReceived, Clock16, reset;
reg[3:0] counter;
initial counter = 4'b0;
initial kill = 1'b0;
always @(posedge Clock16 or posedge reset) begin

	if(reset) counter = 0;
	else if(charReceived) case(counter)
	7: begin kill = 1; counter = 0; end
	default: begin kill = 1'b0; counter = counter + 4'b1; end
	endcase
	else begin counter = 0;	kill = 0; end
	end
	
endmodule
