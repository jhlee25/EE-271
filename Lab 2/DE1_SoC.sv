// Junhyoung Lee & Sangmin Lee
// 10/21/2022
// EE 271
// Lab #2 Task 3 (Extra Credit)
// This program detect a item given with secret mark and tell us whether it is discounted and whether it is stolen

// DE1_SoC module communicates to the physical FPGA board

module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, SW);

	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// 7-bits HEXs
	output logic [2:0] LEDR; 											// 3-bits LEDR
	input logic [9:0] SW;												// 10-bits SW
			
	// LED2 = Discounted, LED0 = Stolen		// LED1 is not used for better readability (a gap between LED2 and LED0)
	// SW8 = u, SW7 = p, SW6 = c, SW0 = M
	// simultaneously represent item numer at HEX0 in decimal
	detector FA (.u(SW[8]), .p(SW[7]), .c(SW[6]), .M(SW[0]), .Dis(LEDR[2]), .St(LEDR[0]));
	seg7 NUM (.bcd(SW[8:6]), .leds0(HEX0), .leds1(HEX1), .leds2(HEX2), .leds3(HEX3), .leds4(HEX4), .leds5(HEX5));
	
endmodule

// This testbench creates all the posiible cases (2^10) of combination of 10 switches
// By the testbench, it is possible to check whether there is correct output by simulating on ModelSim
module DE1_SoC_testbench ();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// output
	logic [2:0] LEDR;											// output
	logic [9:0] SW;											// input
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .LEDR, .SW);
	
	integer i;
	
	initial begin
	
		for (i=0; i<2**10; i++) begin
		
			SW [9:0] = i; #10;
		
		end
		
	end
	
endmodule	