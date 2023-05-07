// Junhyoung Lee & Sangmin Lee
// 12/11/2022
// EE 271
// Lab #6
// This program shows number of cars in the parkinglot with photosensors that detects activity of a car

// DE1_SoC module communicates to the physical FPGA board

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, GPIO_0);
	
	input logic CLOCK_50; 												// 1-bit 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// 6 HEXs of 7-bits
	output logic [9:0] LEDR;											// 10-bits LEDR
	input logic [3:0] KEY; 												// Active low property, 4-bits KEY
	input logic [9:0] SW;												// 10-bits SW
	// SW and KEY cannot be declared if GPIO_0 is declared on LabsLand
	inout logic [33:0] GPIO_0;
	
	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic [31:0] clk;					// 32-bit divided clk
	parameter whichClock = 15;		// 15th of divided clock from clock_divider
	clock_divider cdiv (CLOCK_50, clk);	
	
	logic increment, decrement;
	parkinglot parking (.clk(clk[whichClock]), .reset(GPIO_0[6]), .a(GPIO_0[7]), .b(GPIO_0[8]), .inc(increment), .dec(decrement));
	
	logic [2:0] number;
	counter numberofcar (.out(number), .inc(increment), .dec(decrement), .reset(GPIO_0[6]), .clk(clk[whichClock]));
	
	// Assign GPIO_0[27] (LED) to GPIO_0[5] (switch)
	assign GPIO_0[26] = GPIO_0[7];
	assign GPIO_0[27] = GPIO_0[8];
	
	
	always_ff @ (posedge clk[whichClock]) begin
			
		if (number == 3'b000) begin			// CLEAR 0
			HEX5 <= 7'b1000110;
			HEX4 <= 7'b1000111;
			HEX3 <= 7'b0000110;
			HEX2 <= 7'b0001000;
			HEX1 <= 7'b0001000;
			HEX0 <= 7'b1000000;
		end
		
		if (number == 3'b001) begin     		// 000001
			HEX5 <= 7'b1111111;
			HEX4 <= 7'b1111111;
			HEX3 <= 7'b1111111;
			HEX2 <= 7'b1111111;
			HEX1 <= 7'b1000000;
			HEX0 <= 7'b1111001;
		end
		
		if (number == 3'b010) begin     		// 000002
			HEX5 <= 7'b1111111;
			HEX4 <= 7'b1111111;
			HEX3 <= 7'b1111111;
			HEX2 <= 7'b1111111;
			HEX1 <= 7'b1000000;
			HEX0 <= 7'b0100100;
		end
		
		if (number == 3'b011) begin     		// 000003
			HEX5 <= 7'b1111111;
			HEX4 <= 7'b1111111;
			HEX3 <= 7'b1111111;
			HEX2 <= 7'b1111111;
			HEX1 <= 7'b1000000;
			HEX0 <= 7'b0110000;
		end
		
		if (number == 3'b100) begin     		// 000004
			HEX5 <= 7'b1111111;
			HEX4 <= 7'b1111111;
			HEX3 <= 7'b1111111;
			HEX2 <= 7'b1111111;
			HEX1 <= 7'b1000000;
			HEX0 <= 7'b0011001;
		end
		
		if (number == 3'b101) begin     		// 000005
			HEX5 <= 7'b1111111;
			HEX4 <= 7'b1111111;
			HEX3 <= 7'b1111111;
			HEX2 <= 7'b1111111;
			HEX1 <= 7'b1000000;
			HEX0 <= 7'b0010010;
		end
			
	
	end
				
endmodule


module DE1_SoC_testbench ();

	logic CLOCK_50; 												// 1-bit 50MHz clock
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;		// 6 HEXs of 7-bits
	logic [9:0] LEDR;												// 10-bits LEDR
	logic [3:0] KEY; 												// Active low property, 4-bits KEY
	logic [9:0] SW;												// 10-bits SW
	wire [33:0] GPIO_0;											// SW and KEY cannot be declared if GPIO_0 is declared on LabsLand
	
	logic sw;

	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW, .GPIO_0);
	
	assign GPIO_0[5] = sw;
	
	//clock setup
	parameter clock_period = 100;
		
	initial begin
		CLOCK_50 <= 0;
		// every 50 period, the most divided clock is high and low
		forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
	end //initial
	
	initial begin
			
		sw=1; #50;
		sw=0; #50;
								
	end //initial
		
endmodule	