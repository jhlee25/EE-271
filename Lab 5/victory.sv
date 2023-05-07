// Junhyoung Lee & Sangmin Lee
// 12/06/2022
// EE 271
// Lab #5
// This program is designed to have a game "Tug of War" into an electronic version with computer opponent to play against

// victory module shows who the winner is

module victory #(parameter width = 3) (clk, reset, L, R, NL, NR, winnerL, winnerR, playagain);

	input logic clk, reset;						// given input: 1-bit clk from divided clock, 1-bit reset from user
	input logic L, R, NL, NR;					// given input: 1-bit L or R from user, 1-bit most left (led9) and right (led1) light NL, NR
	output logic [6:0] winnerL, winnerR;	// output: 7-bit winner of the game that displayed at HEX0 and HEX1
	output logic playagain;						// output: 1-bit playagain when one of the player get 1 point
	
	logic [width-1:0] Lcount;					// 3-bit out representing binary value increases by 1
	logic [width-1:0] Rcount;					// 3-bit out representing binary value increases by 1
	
	enum {S0, S1, S2} ps, ns;					// 2-bit of present state and next state
	
	always_comb begin
		
		case (ps)
		
			// S0: initial state "game is on going"
			S0:	if (NL & L & ~R)			ns = S1;
					else if (NR & R & ~L)	ns = S2;
					else							ns = S0;								
													
			// S1: a state "Left is winner"
			S1:	ns = S0;

			// S2: a state "Right is winner"
			S2:	ns = S0;
			
		endcase
		
	end
	
	always_comb	begin					// all the cases up to 7 in decimal
		
		case(Lcount)	
						 // Light: 6543210
			3'b000: winnerL = 7'b1000000; // 0
			3'b001: winnerL = 7'b1111001; // 1
			3'b010: winnerL = 7'b0100100; // 2
			3'b011: winnerL = 7'b0110000; // 3
			3'b100: winnerL = 7'b0011001; // 4
			3'b101: winnerL = 7'b0010010; // 5
			3'b110: winnerL = 7'b0000010; // 6
			3'b111: winnerL = 7'b1111000; // 7
		
		endcase
	
	end

	always_comb	begin					// all the cases up to 7 in decimal
		
		case(Rcount)	
						 // Light: 6543210
			3'b000: winnerR = 7'b1000000; // 0
			3'b001: winnerR = 7'b1111001; // 1
			3'b010: winnerR = 7'b0100100; // 2
			3'b011: winnerR = 7'b0110000; // 3
			3'b100: winnerR = 7'b0011001; // 4
			3'b101: winnerR = 7'b0010010; // 5
			3'b110: winnerR = 7'b0000010; // 6
			3'b111: winnerR = 7'b1111000; // 7
		
		endcase
	
	end	
	
	// sequential logic (DFFs)	
	always_ff @ (posedge clk) begin
		
		begin
			if (reset) begin	
				ps <= S0;
				playagain <= 0;
			end
			
			else if (playagain) begin
				ps <= S0;
				playagain <= 0;
			end
			
			else begin
				ps <= ns;
			end
		end
		
		
		begin
			if (ps == S1 | ps == S2) begin
				playagain <= 1;
			end
			
			else begin
				playagain <= 0;
			end
		end
		
		begin									// upcount when cyber player gets a point
			if (ps==S1) begin
				Lcount <= Lcount + 1;
			end
			
			else if (ps==S2) begin		// upcount when user gets a point
				Rcount <= Rcount + 1;
			end
			
			else begin
				Lcount <= Lcount;
				Rcount <= Rcount;
			end
		end
		
		begin
			if (winnerL == 7'b1111000) begin
				playagain <= 0;
			end
		end
		
		begin
			if (winnerR == 7'b1111000) begin
				playagain <= 0;
			end
		end
		
		begin
			if (reset) begin
				Lcount <= 3'b000;
				Rcount <= 3'b000;
			end
		end
			
	end

endmodule


// This testbench creates combinations for reset and input pressL and pressR in at positive edge of clk 
module victory_testbench ();

	logic clk, reset;						// given input: 1-bit clk from divided clock, 1-bit reset from user
	logic L, R, NL, NR;					// given input: 1-bit L or R from user, 1-bit most left (led9) and right (led1) light NL, NR
	logic [6:0] winnerL, winnerR;		// output: 7-bit winner of the game that displayed at HEX0 and HEX1
	logic playagain;						// output: 1-bit playagain when one of the player get 1 point
	
	victory dut (.clk(clk), .reset(reset), .L(L), .R(R), .NL(NL), .NR(NR), .winnerL(winnerL), .winnerR(winnerR), .playagain(playagain));
	
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
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
						
		reset <= 1; L<=0;	R<=0;	NL<=0;	NR<=0;	@(posedge clk);	// reset
		reset <= 0;											@(posedge clk);	// in game
						NR<=1;								@(posedge clk);	// led 1 is on
						R<=1;									@(posedge clk);	// winner: R
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
															
		$stop; //end simulation	
							
	end //initial

endmodule	