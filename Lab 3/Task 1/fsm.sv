// Junhyoung Lee & Sangmin Lee
// 10/28/2022
// EE 271
// Lab #3 Task 1
// This program detect a 4-bits sequence "1101" with given 32-bits of clock signal

// fsm module to implement a string recognizer for the 4-bits string 1101

module fsm (clk, reset, w, out);

	input  logic  clk, reset, w;	// given input: 32-bits clk from divided clock, 1-bit reset from user,
											//					 1-bit w given input from user
	output logic  out;				// output: 1-bit output is 'on' when given input w makes "1101" as a sequnce

	enum {S0, S1, S2, S3} ps, ns; // present state (3-bits), next state (3-bits)

	// next state logic
	always_comb begin
		case (ps)
			// S0: initial state "000"
			S0: if (w) ns = S1;
					else ns = S0;
			// S1: a state "001"
			S1: if (w) ns = S2;
					else ns = S0;
			// S2: a state "011"
			S2: if (w) ns = S2;
					else ns = S3;
			// S3: a state "110"		
			S3: if (w) ns = S1;
					else ns = S0;
		endcase
	end
			
	assign out = (ps == S3) & w;		// out is '1' when ps is equal to s3 and given input w is 'i'
	
	// sequential logic (DFFs)
		always_ff @(posedge clk) begin
			
			if (reset)		// when reset is pressed, the present state is initial state S0
				ps <= S0;
			else				// when reset is not pressed, present state is next state 
				ps <= ns;	// only at positive edge of clk from divided clock
				
		end				
	
endmodule


// This testbench creates combinations for reset and input w at positive edge of clk from divided clock
// According to present state and next state, it is possible to test cases showing output
module fsm_testbench();

		logic clk, reset, w, out;		// input: 32-bits clk, 1-bit reset, 1-bit w		// output: 1-bit out
		
		fsm dut (.clk, .reset, .w, .out);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			
			clk <= 0;
			
			// every 50 period, the most divided clock is high and low
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
		
		initial begin
		
			reset <= 1;         @(posedge clk); // ns=s0
			reset <= 0; w<=0;   @(posedge clk); // ns=s0
									  @(posedge clk); // ns=s0
			                    @(posedge clk);	// ns=s0
			                    @(posedge clk);	// ns=s0
			            w<=1;   @(posedge clk);	// ns=s1
							w<=0;   @(posedge clk);	// ns=s0
							w<=1;   @(posedge clk);	// ns=s1
									  @(posedge clk);	// ns=s2
			                    @(posedge clk);	// ns=s2
			                    @(posedge clk);	// ns=s2
							w<=0;   @(posedge clk);	// ns=s3
							w<=1;   @(posedge clk);	// ns=s1
							// output:1
									  @(posedge clk); // ns=s2
							w<=0;   @(posedge clk);	// ns=s3
							w<=1;	  @(posedge clk);	// ns=s1
							// output:1
							w<=0;	  @(posedge clk); // ns=s0
							   	  @(posedge clk); // ns=s0
			$stop; //end simulation							
							
		end //initial
		
endmodule		