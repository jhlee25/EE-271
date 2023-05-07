// Junhyoung Lee & Sangmin Lee
// 10/21/2022
// EE 271
// Lab #2 Task 3 (Extra Credit)
// This program detect a item given with secret mark and tell us whether it is discounted and whether it is stolen

// seg7 module translates a givn 4 bits input to a word related to the item on HEXs

module seg7 (bcd, leds0, leds1, leds2, leds3, leds4, leds5);
	
	input logic [3:0] bcd;															// given 4 bits input (represented as upc)
	output logic [6:0] leds0, leds1, leds2, leds3, leds4, leds5;		// HEXs

	always_comb											// all the cases of items that connected to specific word
	
		begin
		
			case(bcd)	
			
				4'b0000: begin							// SHOES
								leds0 = 7'b0010010;	// S
								leds1 = 7'b0000110;	// E
								leds2 = 7'b1000000;	// O
								leds3 = 7'b0001001;	// H
								leds4 = 7'b0010010;	// S
								leds5 = 7'b1111111;	// nothing
							end
				4'b0001: begin							//JULry
								leds0 = 7'b0011001;	// y
								leds1 = 7'b0101111;	// r
								leds2 = 7'b1000111;	// L
								leds3 = 7'b1000001;	// U
								leds4 = 7'b1110001;	// J
								leds5 = 7'b1111111;	// nothing
							end				
				4'b0010: begin
								leds0 = 7'b0100100;	// 2
								leds1 = 7'b1111111;	// nothing
								leds2 = 7'b1111111;	// nothing
								leds3 = 7'b1111111;	// nothing
								leds4 = 7'b1111111;	// nothing
								leds5 = 7'b1111111;	// nothing
							end
				4'b0011: begin							// BigE
								leds0 = 7'b0000110;	// E
								leds1 = 7'b0010000;	// g
								leds2 = 7'b1111001;	// i
								leds3 = 7'b0000000;	// B
								leds4 = 7'b1111111;	// nothing
								leds5 = 7'b1111111;	// nothing
							end
				4'b0100: begin							// SUit
								leds0 = 7'b0000111;	// t
								leds1 = 7'b1111001;	// i
								leds2 = 7'b1000001;	// U
								leds3 = 7'b0010010;	// S
								leds4 = 7'b1111111;	// nothing
								leds5 = 7'b1111111;	// nothing
							end
				4'b0101: begin							// COAt
								leds0 = 7'b0000111;	// t
								leds1 = 7'b0001000;	// A
								leds2 = 7'b1000000;	// O
								leds3 = 7'b1000110;	// C
								leds4 = 7'b1111111;	// nothing
								leds5 = 7'b1111111;	// nothing
							end
				4'b0110: begin							// SOCgS
								leds0 = 7'b0010010;	// S
								leds1 = 7'b0010000;	// g
								leds2 = 7'b1000110;	// C
								leds3 = 7'b1000000;	// O
								leds4 = 7'b0010010;	// S
								leds5 = 7'b1111111;	// nothing
							end
				4'b0111: begin
								leds0 = 7'b1111000;	// 7
								leds1 = 7'b1111111;	// nothing
								leds2 = 7'b1111111;	// nothing
								leds3 = 7'b1111111;	// nothing
								leds4 = 7'b1111111;	// nothing
								leds5 = 7'b1111111;	// nothing
							end
				4'b1000: begin
								leds0 = 7'b0000000;	// 8
								leds1 = 7'b1111111;	// nothing
								leds2 = 7'b1111111;	// nothing
								leds3 = 7'b1111111;	// nothing
								leds4 = 7'b1111111;	// nothing
								leds5 = 7'b1111111;	// nothing
							end
				4'b1001: begin
								leds0 = 7'b0010000;	// 9
								leds1 = 7'b1111111;	// nothing
								leds2 = 7'b1111111;	// nothing
								leds3 = 7'b1111111;	// nothing
								leds4 = 7'b1111111;	// nothing
								leds5 = 7'b1111111;	// nothing
							end
				default: begin
								leds0 = 7'bX;
								leds1 = 7'bX;
								leds2 = 7'bX;
								leds3 = 7'bX;
								leds4 = 7'bX;
								leds5 = 7'bX;
							end
			
			endcase
	
		end

endmodule

// This testbench creates all possible combinations (2^4) of bcd
// By the testbench, it is possible to check whether there is correct output by simulating on ModelSim 
module seg7_testbench ();
	
	logic [3:0] bcd;														// input
	logic [6:0] leds0, leds1, leds2, leds3, leds4, leds5;		// output
	
	seg7 dut (.bcd(bcd), .leds0(leds0), .leds1(leds1), .leds2(leds2), .leds3(leds3), .leds4(leds4), .leds5(leds5));
	
	integer i;
	
	initial begin
		
		for (i=0; i<2**4; i++) begin
			
			{bcd} = i; #10;
			
		end
	
	end
	
endmodule	