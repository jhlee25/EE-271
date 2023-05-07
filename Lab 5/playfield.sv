// Junhyoung Lee & Sangmin Lee
// 12/06/2022
// EE 271
// Lab #5
// This program is designed to have a game "Tug of War" into an electronic version with computer opponent to play against

// playfield module controls all 9 lights and shows the winner at display

module playfield (clk, reset, pressL, pressR, LEDR, resultL, resultR);

	input logic clk, reset, pressL, pressR;	// given input: 1-bit clk from divided clock, 1-bit reset from user, 1-bit pressL or pressR from user
	output logic [9:1] LEDR;						// output: 9-bit led that shows current player's position
	output logic [6:0] resultL, resultR;		// output: 7-bit result of the game that displayed at HEX0 and HEX1
		
	normallight n1 (.clk(clk), .reset(reset), .L(pressL), .R(pressR), .NL(LEDR[2]), .NR(1'b0), .led(LEDR[1]), .playagain(playagain));
	normallight n2 (.clk(clk), .reset(reset), .L(pressL), .R(pressR), .NL(LEDR[3]), .NR(LEDR[1]), .led(LEDR[2]), .playagain(playagain));
	normallight n3 (.clk(clk), .reset(reset), .L(pressL), .R(pressR), .NL(LEDR[4]), .NR(LEDR[2]), .led(LEDR[3]), .playagain(playagain));
	normallight n4 (.clk(clk), .reset(reset), .L(pressL), .R(pressR), .NL(LEDR[5]), .NR(LEDR[3]), .led(LEDR[4]), .playagain(playagain));
	centerlight c5 (.clk(clk), .reset(reset), .L(pressL), .R(pressR), .NL(LEDR[6]), .NR(LEDR[4]), .led(LEDR[5]), .playagain(playagain));
	normallight n6 (.clk(clk), .reset(reset), .L(pressL), .R(pressR), .NL(LEDR[7]), .NR(LEDR[5]), .led(LEDR[6]), .playagain(playagain));
	normallight n7 (.clk(clk), .reset(reset), .L(pressL), .R(pressR), .NL(LEDR[8]), .NR(LEDR[6]), .led(LEDR[7]), .playagain(playagain));
	normallight n8 (.clk(clk), .reset(reset), .L(pressL), .R(pressR), .NL(LEDR[9]), .NR(LEDR[7]), .led(LEDR[8]), .playagain(playagain));
	normallight n9 (.clk(clk), .reset(reset), .L(pressL), .R(pressR), .NL(1'b0), .NR(LEDR[8]), .led(LEDR[9]), .playagain(playagain));
	
	victory winner (.clk(clk), .reset(reset), .L(pressL), .R(pressR), .NL(LEDR[9]), .NR(LEDR[1]), .winnerL(resultL), .winnerR(resultR), .playagain(playagain));
	
endmodule


// This testbench creates combinations for reset and input pressL and pressR at positive edge of clk 
module playfield_testbench ();

	logic clk, reset, pressL, pressR;	// input: 1-bit clk from divided clock, 1-bit reset from user, 1-bit pressL or pressR from user
	logic [9:1] LEDR;							// output: 9-bit led that shows current player's position
	logic [6:0] resultL, resultR;			// output: 7-bit result of the game that displayed at HEX0 and HEX1
	
	playfield dut (.clk(clk), .reset(reset), .pressL(pressL), .pressR(pressR), .LEDR(LEDR), .resultL(resultL), .resultR(resultR));
	
	//clock setup
	parameter clock_period = 100;
		
	initial begin
		clk <= 0;
		// every 50 period, the most divided clock is high and low
		forever #(clock_period /2) clk <= ~clk;		
	end //initial
		
	initial begin
	
		reset <= 1;	pressR<=0;		@(posedge clk);	// led 5 (reset)
		reset <= 0; pressL<=1;		@(posedge clk);	// led 6
											@(posedge clk);	// led 6
											@(posedge clk);	// led 6
						pressL<=0;		@(posedge clk);
						pressL<=1;		@(posedge clk);	// led 7
						pressL<=0;		@(posedge clk);
						pressL<=1;		@(posedge clk);	// led 8
						pressL<=0;		@(posedge clk);
						pressL<=1;		@(posedge clk);	// led 9
						pressL<=0;		@(posedge clk);
						pressL<=1;		@(posedge clk);	// winner: L
						pressL<=0;		@(posedge clk);
						
		reset <= 1;						@(posedge clk);	// led 5 (reset)
		reset <= 0; pressR<=1;		@(posedge clk);	// led 4
											@(posedge clk);	// led 4
											@(posedge clk);	// led 4
						pressR<=0;		@(posedge clk);
						pressR<=1;		@(posedge clk);	// led 3
						pressR<=0;		@(posedge clk);
						pressR<=1;		@(posedge clk);	// led 2
						pressR<=0;		@(posedge clk);
						
						pressL<=1;		@(posedge clk);	// led 3
						pressL<=0;		@(posedge clk);
						pressL<=1;		@(posedge clk);	// led 4
						pressL<=0;		@(posedge clk);
						
						pressR<=1;		@(posedge clk);	// led 3
						pressR<=0;		@(posedge clk);
						pressR<=1;		@(posedge clk);	// led 2
						pressR<=0;		@(posedge clk);
						pressR<=1;		@(posedge clk);	// led 1
						pressR<=0;		@(posedge clk);
						pressR<=1;		@(posedge clk);	// winner: R
						pressR<=0;		@(posedge clk);
										
		$stop; //end simulation							
							
		end //initial

endmodule	