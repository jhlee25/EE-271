// Junhyoung Lee & Sangmin Lee
// 12/06/2022
// EE 271
// Lab #5
// This program is designed to have a game "Tug of War" into an electronic version with computer opponent to play against

//	compbutton module create button press for cyber player

module compbutton (clk, reset, LFSR, SW, press);

	input logic clk, reset;					// given input: 1-bit clk from divided clock, 1-bit reset from user
	input logic [9:0] LFSR;					// given input: 10-bit LFSR that generate a randum number
	input logic [8:0] SW;					// given input: 9-bit SW that made with user's press of SWs
	output logic press;						// output: 1-bit output (1 for SW > LFSR, 0 for else)
	
	logic [9:0] extendSW;					// 10-bit extended SWs which was 9-bit originally
	
	assign extendSW = {1'b0, SW};
	
	Comparator comppress (.A(extendSW), .B(LFSR), .out(press));

endmodule


module compbutton_testbench ();

	logic clk, reset;							// given input: 1-bit clk from divided clock, 1-bit reset from user
	logic [9:0] LFSR;							// given input: 10-bit LFSR that generate a randum number
	logic [8:0] SW;							// given input: 9-bit SW that made with user's press of SWs
	logic press;								// output: 1-bit output (1 for SW > LFSR, 0 for else)
	
	compbutton dut (.clk(clk), .reset(reset), .LFSR(LFSR), .SW(SW), .press(press));
	
	//clock setup
	parameter clock_period = 100;
		
	initial begin
		clk <= 0;
		// every 50 period, the most divided clock is high and low
		forever #(clock_period /2) clk <= ~clk;		
	end //initial
	
	initial begin
	
		reset <= 1;																@(posedge clk);
		reset <= 0;	SW = 9'b010000000; 	LFSR = 10'b0100000000;	@(posedge clk);
																					@(posedge clk);
																					@(posedge clk);
																					@(posedge clk);
													LFSR = 10'b0000100000;	@(posedge clk);
																					@(posedge clk);
																					@(posedge clk);
																					@(posedge clk);

		$stop; //end simulation
							
	end //initial
	
endmodule	