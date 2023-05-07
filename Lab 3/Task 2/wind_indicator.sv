// Junhyoung Lee & Sangmin Lee
// 11/03/2022
// EE 271
// Lab #3 Task 2
// This program indicates wind direction in 3-bits by given two 1-bit inputs within 3 stages (Calm, Right to Left, Left to Right)

// wind indicator module shows direction of wind in 3-bits with given two 1-bit inputs

module wind_indicator (clk, reset, w, out);

	input logic clk, reset;						// given input: 32-bits clk from divided clock, 1-bit reset from user
	input logic [1:0] w;							// given input: w given 2-bit input from user
	output logic [2:0] out;						// output: 3-bit output representing the direction of wind

	enum {S0, S1, S2, S3, S4} ps, ns; 		// 3-bit of present state and next state

	// next state logic
	always_comb begin
		case (ps)

			// S0: initial state "000"
			S0: if (w == 2'b0) ns = S4;
					else if (w == 2'b01) ns = S2;
					else if (w == 2'b10) ns = S3;
					else ns = S0;
					
			// S1: a state "010"
			S1: if (w == 2'b0) ns = S4;
					else if (w == 2'b01) ns = S3;
					else if (w == 2'b10) ns = S2;
					else ns = S1;
					
			// S2: a state "001"
			S2: if (w == 2'b0) ns = S4;
					else if (w == 2'b01) ns = S1;
					else if (w == 2'b10) ns = S3;
					else ns = S2;
					
			// S3: a state "100"
			S3: if (w == 2'b0) ns = S1;
					else if (w == 2'b01) ns = S2;
					else if (w == 2'b10) ns = S1;
					else ns = S3;
					
			// S4: a state "101"
			S4: if (w == 2'b0) ns = S1;
					else if (w == 2'b01) ns = S2;
					else if (w == 2'b10) ns = S3;
					else ns = S4;		
		
		endcase			
	end
	
	// each of 3-bit output is determined by what present state is and what the input is
	assign out[2] = ((ps==S0) & ~w[0]) + ((ps==S2) & ~w[0]) + ((ps==S1) & ~w[1]) + ((ps==S4) & w[1] & ~w[0]);
	assign out[1] = ((ps==S2) & ~w[1] & w[0]) + ((ps==S3) & ~w[0]) + ((ps==S4) & ~w[1] & ~w[0]);
	assign out[0] = ((ps==S0) & ~w[1]) + ((ps==S2) & ~w[1] & ~w[0]) + ((ps==S1) & ~w[0]) + ((ps==S3) & ~w[1] & w[0]) + ((ps==S4) & ~w[1] & w[0]);
	
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
module wind_indicator_testbench();

	logic clk, reset;						// input: 32-bits clk, 1-bit reset
	logic [1:0] w;							// input: 2-bits w
	logic [2:0] out;						// output: 3-bits out
		
	wind_indicator dut (.clk, .reset, .w, .out);
		
	//clock setup
	parameter clock_period = 100;
		
		initial begin
			
			clk <= 0;
			
			// every 50 period, the most divided clock is high and low
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
		
		initial begin
		
			reset <= 1;         		@(posedge clk); // ns=s0
			reset <= 0; w<=2'b0;		@(posedge clk); // ns=s4	// output: 101
										   @(posedge clk); // ns=s1	// output: 010
			            w<=2'b01;   @(posedge clk); // ns=s3	// output: 100
							w<=2'b0;    @(posedge clk); // ns=s1	// output: 010
							w<=2'b10;   @(posedge clk); // ns=s2	// output: 001
											@(posedge clk); // ns=s3	// output: 100
											@(posedge clk); // ns=s1	// output: 010
											@(posedge clk); // ns=s2	// output: 001
							w<=2'b01;   @(posedge clk); // ns=s1	// output: 010
											@(posedge clk); // ns=s3	// output: 100
											@(posedge clk); // ns=s2	// output: 001
							w<=2'b0;    @(posedge clk); // ns=s4	// output: 101
											@(posedge clk); // ns=s1	// output: 010
											@(posedge clk); // ns=s4	// output: 101
							
			$stop; //end simulation							
							
		end //initial
		
endmodule		