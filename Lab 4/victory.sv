// Junhyoung Lee & Sangmin Lee
// 11/17/2022
// EE 271
// Lab #4
// This program is designed to have a game "Tug of War" into an electronic version

// victory module shows who the winner is

module victory (clk, reset, L, R, NL, NR, winner);

	input logic clk, reset;						// given input: 1-bit clk from CLOCK_50, 1-bit reset from user
	input logic L, R, NL, NR;					// given input: 1-bit L or R from user, 1-bit most left (led9) and right (led1) light NL, NR
	output logic [6:0] winner; 				// output: 7-bit winner of the game that displayed at HEX0
	
	enum {S0, S1, S2} ps, ns;					// 2-bit of present state and next state
	
	always_comb begin
		
		case (ps)
		
			// S0: initial state "game is on going"
			S0:	if (NL & L & ~R)			ns = S1;
					else if (NR & R & ~L)	ns = S2;
					else							ns = S0;
			
			// S1: a state "Left is winner"
			S1:	ns = S1;
					
			// S2: a state "Right is winner"
			S2:	ns = S2;
		
		endcase
		
	end
	
	// assign winner based on the states S0, S1, and S2
	always_comb begin
	
		if (ps==S1)
			winner = 7'b1000111; // L
		else if (ps==S2)
			winner = 7'b0001000;	// R
		else
			winner = 7'b1110111; // _ (in game)
	
	end
	
	// sequential logic (DFFs)
	always_ff @(posedge clk) begin
	
		if (reset)
			ps <= S0;
		else
			ps <= ns;
	end
	
endmodule


// This testbench creates combinations for reset and input pressL and pressR in at positive edge of clk 
module victory_testbench ();

	logic clk, reset;						// given input: 1-bit clk from CLOCK_50, 1-bit reset from user
	logic L, R, NL, NR;					// given input: 1-bit L or R from user, 1-bit most left (led9) and right (led1) light NL, NR
	logic [6:0] winner; 					// output: 7-bit winner of the game that displayed at HEX0
	
	victory dut (.clk(clk), .reset(reset), .L(L), .R(R), .NL(NL), .NR(NR), .winner(winner));
	
	//clock setup
	parameter clock_period = 100;
		
	initial begin
		clk <= 0;
		// every 50 period, the most divided clock is high and low
		forever #(clock_period /2) clk <= ~clk;		
	end //initial
		
	initial begin
	
		reset <= 1;	L<=0;	R<=0;	NL<=0;	NR<=0;	@(posedge clk);
		reset <= 0;											@(posedge clk);	// in game
						NL<=1;								@(posedge clk);	// led 9 is on
						L<=1;									@(posedge clk);	// winner: L
						
		reset <= 1; L<=0;	R<=0;	NL<=0;	NR<=0;	@(posedge clk);	// reset
		reset <= 0;											@(posedge clk);	// in game
						NR<=1;								@(posedge clk);	// led 1 is on
						R<=1;									@(posedge clk);	// winner: R
																@(posedge clk);
																@(posedge clk);
															
		$stop; //end simulation							
							
		end //initial

endmodule	