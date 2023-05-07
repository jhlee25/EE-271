 // Junhyoung Lee & Sangmin Lee
// 10/28/2022
// EE 271
// Lab #3 Task 1
// This program detect a 4-bits sequence "1101" with given 32-bits of clock signal

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
	// SW0 = input		// LEDR0 = light on when a sequence "1101" is detected
	fsm f1 (.clk(clk[whichClock]), .reset(reset), .w(SW[0]), .out(LEDR[0]));

endmodule

// This testbench creates combinations for KEY0 and SW0 at positive edge of CLOCOK_50
// According to present state and next state, it is possible to test cases showing output
module DE1_SoC_testbench ();

	logic CLOCK_50; // 50MHz clock							// input
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;		// output: 6 HEXs of 7-bits
	logic [9:0] LEDR;												// output: 10-bits LEDR
	logic [3:0] KEY; // Active low property				// input: 3-bits KEY
	logic [9:0] SW;												// input: 10-bits SW
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	fsm dut2 (.clk(CLOCK_50), .reset(KEY[0]), .w(SW[0]), .out(LEDR[0]));
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
	
		CLOCK_50 <= 0;
		
		// every 50 period, the most divided clock is high and low
		forever #(CLOCK_PERIOD / 2) CLOCK_50 <= ~CLOCK_50;
		
	end
	
	initial begin
	
		KEY[0] <= 1;      	   @(posedge CLOCK_50); // ns=s0
		KEY[0] <= 0; SW[0]<=0;	@(posedge CLOCK_50); // ns=s0
										@(posedge CLOCK_50); // ns=s0
										@(posedge CLOCK_50); // ns=s0
										@(posedge CLOCK_50); // ns=s0
						 SW[0]<=1;  @(posedge CLOCK_50); // ns=s1
						 SW[0]<=0;  @(posedge CLOCK_50); // ns=s0
						 SW[0]<=1;  @(posedge CLOCK_50); // ns=s1
										@(posedge CLOCK_50); // ns=s2
										@(posedge CLOCK_50); // ns=s2
										@(posedge CLOCK_50); // ns=s2
						 SW[0]<=0;  @(posedge CLOCK_50); // ns=s3
						 SW[0]<=1;  @(posedge CLOCK_50); // ns=s1
						 // output:1
										@(posedge CLOCK_50); // ns=s2
						 SW[0]<=0;  @(posedge CLOCK_50); // ns=s3
						 SW[0]<=1;	@(posedge CLOCK_50); // ns=s1
						 // output:1
						 SW[0]<=0;	@(posedge CLOCK_50); // ns=s0
										@(posedge CLOCK_50); // ns=s0
		$stop; //end simulation							
							
	end //initial
		
endmodule	