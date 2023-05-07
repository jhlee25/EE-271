// Junhyoung Lee & Sangmin Lee
// 11/03/2022
// EE 271
// Lab #3 Task 2
// This program indicates wind direction in 3-bits by given two 1-bit inputs within 3 stages (Calm, Right to Left, Left to Right)

// clock_divider module takes in a clock signal, divides the clock cycle and outputs 32
// divided clock signals of varying frequency
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... ,[23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...

module clock_divider (clock, divided_clocks);
	
	input logic clock;									// input: given clock
	output logic [31:0] divided_clocks = 32'b0;	// output: 32-bits of divided clock with initialized with all '0'
	
	always_ff @(posedge clock) begin
		
		divided_clocks <= divided_clocks + 1;		// at every positive edge, each bit turend as high while it is divided
		
	end
	
endmodule


module clock_divider_testbench();
	logic clock;							// input
	logic [31:0] divided_clocks;		// output: 32-bits of divided clock
	
	clock_divider dut (.clock, .divided_clocks);
	
	// set up the clock
	parameter clock_period = 100;
	
	initial begin

		clock <= 0;
		
		// every 50 period, the most divided clock is high and low
		forever #(clock_period /2) clock <= ~clock;
					
	end
	
	integer i;

	initial begin

		// shows divided clock up to 25th of given clock
		for (i=0; i<2**26; i++) begin
			
			@(posedge clock);		// @(posedge clock): 1 clock cycle
			
		end
		
		$stop;
		
	end
	
endmodule
