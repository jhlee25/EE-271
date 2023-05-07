// Junhyoung Lee & Sangmin Lee
// 11/17/2022
// EE 271
// Lab #4
// This program is designed to have a game "Tug of War" into an electronic version

// DE1_SoC module communicates to the physical FPGA board

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	input logic CLOCK_50; 												// 1-bit 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// 6 HEXs of 7-bits
	output logic [9:0] LEDR;											// 10-bits LEDR
	input logic [3:0] KEY; 												// Active low property, 4-bits KEY
	input logic [9:0] SW;												// 10-bits SW

	// Since HEX1~5 is not used, these are turned off
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	logic L, R;
	keypress sync (.clk(CLOCK_50), .reset(SW[0]), .leftkey(KEY[3]), .rightkey(KEY[0]), .leftpress(L), .rightpress(R));
	
	// outputs from keypress module are inputs for playfield module
	playfield play (.clk(CLOCK_50), .reset(SW[0]), .pressL(L), .pressR(R), .LEDR(LEDR[9:1]), .result(HEX0));
			
endmodule


// This testbench creates combinations for SW0 (reset) and KEY3 and KEY0 at positive edge of CLOCOK_50
module DE1_SoC_testbench ();

	logic CLOCK_50; 												// 1-bit 50MHz clock
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;		// 6 HEXs of 7-bits
	logic [9:0] LEDR;												// 10-bits LEDR
	logic [3:0] KEY; 												// Active low property, 4-bits KEY
	logic [9:0] SW;												// 10-bits SW
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	//clock setup
	parameter clock_period = 100;
		
	initial begin
		CLOCK_50 <= 0;
		// every 50 period, the most divided clock is high and low
		forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
	end //initial
	
	initial begin
												
		SW[0] <= 1;	KEY[0]<=0;		@(posedge CLOCK_50);	// led 5 (reset)
		SW[0] <= 0; KEY[3]<=1;		@(posedge CLOCK_50);	// led 6
											@(posedge CLOCK_50);	// led 6
											@(posedge CLOCK_50);	// led 6
						KEY[3]<=0;		@(posedge CLOCK_50);
						KEY[3]<=1;		@(posedge CLOCK_50);	// led 7
						KEY[3]<=0;		@(posedge CLOCK_50);
						KEY[3]<=1;		@(posedge CLOCK_50);	// led 8
						KEY[3]<=0;		@(posedge CLOCK_50);
						KEY[3]<=1;		@(posedge CLOCK_50);	// led 9
						KEY[3]<=0;		@(posedge CLOCK_50);
						KEY[3]<=1;		@(posedge CLOCK_50);	// winner: L
						KEY[3]<=0;		@(posedge CLOCK_50);
						
		SW[0] <= 1;						@(posedge CLOCK_50);	// led 5 (reset)
		SW[0] <= 0; KEY[0]<=1;		@(posedge CLOCK_50);	// led 4
											@(posedge CLOCK_50);	// led 4
											@(posedge CLOCK_50);	// led 4
						KEY[0]<=0;		@(posedge CLOCK_50);
						KEY[0]<=1;		@(posedge CLOCK_50);	// led 3
						KEY[0]<=0;		@(posedge CLOCK_50);
						KEY[0]<=1;		@(posedge CLOCK_50);	// led 2
						KEY[0]<=0;		@(posedge CLOCK_50);
						
						KEY[3]<=1;		@(posedge CLOCK_50);	// led 3
						KEY[3]<=0;		@(posedge CLOCK_50);
						KEY[3]<=1;		@(posedge CLOCK_50);	// led 4
						KEY[3]<=0;		@(posedge CLOCK_50);
						
						KEY[0]<=1;		@(posedge CLOCK_50);	// led 3
						KEY[0]<=0;		@(posedge CLOCK_50);
						KEY[0]<=1;		@(posedge CLOCK_50);	// led 2
						KEY[0]<=0;		@(posedge CLOCK_50);
						KEY[0]<=1;		@(posedge CLOCK_50);	// led 1
						KEY[0]<=0;		@(posedge CLOCK_50);
						KEY[0]<=1;		@(posedge CLOCK_50);	// winner: R
						KEY[0]<=0;		@(posedge CLOCK_50);	
	
		$stop; //end simulation							
							
	end //initial
		
endmodule	