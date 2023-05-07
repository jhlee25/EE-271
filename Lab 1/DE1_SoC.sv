// Junhyoung Lee & Sangmin Lee
// 10/14/2022
// EE 271
// Lab #1
// This program adds given two number and shows the result with number of LEDs in binary

// DE1_SoC module communicates to the physical FPGA board

module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);

	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// 6 HEX displays (7 segment for each HEX)
	output logic [4:0] LEDR;											// 5 LEDs (shows outcome of the fullAdder)
	input logic [3:0] KEY;												// KEYs are shown on the FPGA but not used
	input logic [8:0] SW;												// 9 switches (switches of A, B, and cin)
	
	// The number A can be represented with switches #1 - #4
	// The number B can be represented with switches #5 - #8
	// The number cin can be represented with switches #0
	// The result of sum of A, B, and cin will be presented on LED #0 - #4
	fullAdder4 FA (.A(SW[4:1]), .B(SW[8:5]), .cin(SW[0]), .sum(LEDR[3:0]), .cout(LEDR[4]));
	
	// word "Adding" is showing
	assign HEX0 = 7'b0010000;	// 'g'
	assign HEX1 = 7'b0101011;	// 'n'
	assign HEX2 = 7'b1111001;	// 'i'
	assign HEX3 = 7'b0100001;	// 'd'
	assign HEX4 = 7'b0100001;	// 'd'
	assign HEX5 = 7'b0001000;	// 'A'
	
	endmodule	
	
module DE1_SoC_testbench();
	
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [4:0] LEDR;
	logic [3:0] KEY;
	logic [8:0] SW;
		
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
		
	integer i;
	
	initial begin
	
		for (i=0; i<2**9; i++) begin
			SW[8:0] = i; #10;	// create all the posiible cases (2^9) of combination of 9 switches
		end

	end

endmodule	