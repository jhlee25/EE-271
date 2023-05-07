// Junhyoung Lee & Sangmin Lee
// 11/03/2022
// EE 271
// Lab #3 Task 2
// This program indicates wind direction in 3-bits by given two 1-bit inputs within 3 stages (Calm, Right to Left, Left to Right)

// DE1_SoC module communicates to the physical FPGA board

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	input logic CLOCK_50; 												// 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// 6 HEXs of 7-bits
	output logic [9:0] LEDR;											// 10-bits LEDR
	input logic [3:0] KEY; 												// Active low property, 3-bits KEY
	input logic [9:0] SW;												// 10-bits SW

	// Generate clk off of CLOCK_50, whichClock picks rate.

	logic [31:0] clk;

	parameter whichClock = 25;		// 25th of divided clock from clock_divider

	clock_divider cdiv (CLOCK_50, clk);

	logic reset;  // configure reset

	assign reset = ~KEY[0]; // Reset when KEY[0] is pressed
	
	assign LEDR[5] = clk[whichClock];
	
	// instantiates Hazard light and assigned corresponding ports
	// SW1 & SW0 = 2-bit input
	// LEDR2 & LEDR1 & LEDR0 = three lights to display the corresponding sequence of lights (Calm, Right to Left, Left to Right)
	wind_indicator f1 (.clk(clk[whichClock]), .reset(reset), .w(SW[1:0]), .out(LEDR[2:0]));

endmodule

// This testbench creates combinations for KEY0 and SW1 and SW0 at positive edge of CLOCOK_50
// According to present state and next state, it is possible to test cases showing 3-bit ssoutput
module DE1_SoC_testbench ();

	logic CLOCK_50; // 50MHz clock							// input
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;		// output: 6 HEXs of 7-bits
	logic [9:0] LEDR;												// output: 10-bits LEDR
	logic [3:0] KEY; // Active low property				// input: 3-bits KEY
	logic [9:0] SW;												// input: 10-bits SW
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	wind_indicator dut2 (.clk(CLOCK_50), .reset(KEY[0]), .w(SW[1:0]), .out(LEDR[2:0]));
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
	
		CLOCK_50 <= 0;
		
		// every 50 period, the most divided clock is high and low
		forever #(CLOCK_PERIOD / 2) CLOCK_50 <= ~CLOCK_50;
		
	end
	
	initial begin
												
		KEY[0] <= 1;         				@(posedge CLOCK_50); // ns=s0
		KEY[0] <= 0;	SW[1:0]<=2'b0;		@(posedge CLOCK_50); // ns=s4	// output: 101
													@(posedge CLOCK_50); // ns=s1	// output: 010
							SW[1:0]<=2'b01;   @(posedge CLOCK_50); // ns=s3	// output: 100
							SW[1:0]<=2'b0;    @(posedge CLOCK_50); // ns=s1	// output: 010
							SW[1:0]<=2'b10;   @(posedge CLOCK_50); // ns=s2	// output: 001
													@(posedge CLOCK_50); // ns=s3	// output: 100
													@(posedge CLOCK_50); // ns=s1	// output: 010
													@(posedge CLOCK_50); // ns=s2	// output: 001
							SW[1:0]<=2'b01;   @(posedge CLOCK_50); // ns=s1	// output: 010
													@(posedge CLOCK_50); // ns=s3	// output: 100
													@(posedge CLOCK_50); // ns=s2	// output: 001
							SW[1:0]<=2'b0;    @(posedge CLOCK_50); // ns=s4	// output: 101
													@(posedge CLOCK_50); // ns=s1	// output: 010
													@(posedge CLOCK_50); // ns=s4	// output: 101	
	
		$stop; //end simulation							
							
	end //initial
		
endmodule	