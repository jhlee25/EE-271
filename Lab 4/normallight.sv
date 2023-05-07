// Junhyoung Lee & Sangmin Lee
// 11/17/2022
// EE 271
// Lab #4
// This program is designed to have a game "Tug of War" into an electronic version

// normallight module controls led 1,2,3,4 and 6,7,8,9 according to player's input and neighbor leds

module normallight (clk, reset, L, R, NL, NR, led);

	input logic clk, reset, L, R, NL, NR;	// given input: 1-bit clk from CLOCK_50, 1-bit reset from user, 1-bit L or R from user, 1-bit neighbor light NL, NR
	output logic led;								// output: 1-bit led that can be on and off depend on input L, R, NL, and NR
	
	enum {S0, S1} ps, ns;						// 1-bit of present state and next state
	
	// next state logic
	always_comb begin
		
		case (ps)
			
			// S0: initial state "led is on"
			S0:	if (L & ~R & ~NL & ~NR)			ns = S1;
					else if (~L & R & ~NL & ~NR)	ns = S1;
					else 									ns = S0;
			
			// S1: a state "led is off"
			S1:	if (L & ~R & ~NL & NR) 			ns = S0;
					else if (~L & R & NL & ~NR)	ns = S0;
					else 									ns = S1;
		
		endcase
	
	end
	
	assign led = (ps == S0);
	
	// sequential logic (DFFs)
	always_ff @(posedge clk) begin
	
		if (reset)		
			ps <= S1;
		else				
			ps <= ns;
	
	end
	
endmodule


// This testbench creates combinations for reset and input L, R, NL, and NR at positive edge of clk
module normallight_testbench ();

	logic clk, reset, L, R, NL, NR;	// given input: 1-bit clk from CLOCK_50, 1-bit reset from user, 1-bit L or R from user, 1-bit neighbor light NL, NR
	logic led;								// output: 1-bit led that can be on and off depend on input L, R, NL, and NR
	
	normallight dut (.clk(clk), .reset(reset), .L(L), .R(R), .NL(NL), .NR(NR), .led(led));
	
	//clock setup
	parameter clock_period = 100;
		
	initial begin
		clk <= 0;
		// every 50 period, the most divided clock is high and low
		forever #(clock_period /2) clk <= ~clk;		
	end //initial
		
	initial begin
	
		reset <= 1;	L<=0; NL<=1; NR<=0;		@(posedge clk); // led 5 (reset)
		reset <= 0; 
						R<=1; NL<=1;				@(posedge clk); // led 4
														@(posedge clk);
						R<=0; NL<=0;				@(posedge clk);
														@(posedge clk);
						R<=1; NL<=1;				@(posedge clk); // led 3
														@(posedge clk);
						R<=0; NL<=0;				@(posedge clk);
														@(posedge clk);
						R<=1; NL<=1;				@(posedge clk); // led 2
														@(posedge clk);
						R<=0; NL<=0;				@(posedge clk);
														@(posedge clk);
						R<=1; NL<=1;				@(posedge clk); // led 1
														@(posedge clk);
						R<=0; NL<=0;				@(posedge clk);
														@(posedge clk);
						R<=1; NL<=1;				@(posedge clk); // winner: R
														@(posedge clk);
						R<=0; NL<=0;				@(posedge clk);
														@(posedge clk);
										
		$stop; //end simulation							
							
		end //initial

endmodule	