// Junhyoung Lee & Sangmin Lee
// 12/11/2022
// EE 271
// Lab #6
// This program shows number of cars in the parkinglot with photosensors that detects activity of a car

// parkinglot module detect the activity of a car by photosensors

module parkinglot (clk, reset, a, b, inc, dec);

	input logic clk, reset;			// given input: 1-bit clk from divided clock, 1-bit reset from user
	input logic a, b;					// given input: 1-bit a and b from user input by SW 1 and SW 0
	output logic inc, dec;			// output: 1-bit inc and dec represents either enter (inc) or exit (dec)
	
	enum {S0, S1, S2, S3} ps, ns;	// 2-bit of present state and next state
	
	// next state logic
	always_ff @ (posedge clk) begin
		
		case (ps)
			
			// S0: initial state "unblocked"
			S0:	if (a & ~b) begin				ns <= S1; inc <= 0; dec <= 0; end	// entering
					else if (~a & b) begin 		ns <= S2; inc <= 0; dec <= 0; end	// exiting
					else if (a & b) begin 		ns <= S3; inc <= 0; dec <= 0; end
					else begin						ns <= S0; inc <= 0; dec <= 0; end
			
			// S1: a state "sensor A"
			S1:	if (a & ~b) begin				ns <= S1; inc <= 0; dec <= 0; end
					else if (a & b) begin		ns <= S3; inc <= 0; dec <= 0; end
					else if (~a & ~b) begin		ns <= S0; inc <= 0; dec <= 1; end	// decrement
					else begin						ns <= S0; inc <= 0; dec <= 0; end

			// S2: a state "sensor B"
			S2:	if (~a & b) begin 			ns <= S2; inc <= 0; dec <= 0; end
					else if (a & b) begin		ns <= S3; inc <= 0; dec <= 0; end
					else if (~a & ~b)	begin		ns <= S0; inc <= 1; dec <= 0; end	// increment
					else begin						ns <= S0; inc <= 0; dec <= 0; end
					
			// S3: a state "blocked"
			S3:	if (~a & b) begin 			ns <= S2; inc <= 0; dec <= 0; end
					else if (a & ~b) begin		ns <= S1; inc <= 0; dec <= 0; end
					else if (a & b) begin		ns <= S3; inc <= 0; dec <= 0; end
					else begin						ns <= S0; inc <= 0; dec <= 0; end
		
		endcase
	
	end

	
endmodule


module parkinglot_testbench ();

	logic clk, reset;			// given input: 1-bit clk from divided clock, 1-bit reset from user
	logic a, b;					// given input: 1-bit a and b from user input by SW 1 and SW 0
	logic inc, dec;			// output: 1-bit inc and dec represents either enter (inc) or exit (dec)
	
	parkinglot dut (.clk(clk), .reset(reset), .a(a), .b(b), .inc(inc), .dec(dec));

	//clock setup
	parameter clock_period = 100;
		
	initial begin
		clk <= 0;
		// every 50 period, the most divided clock is high and low
		forever #(clock_period /2) clk <= ~clk;		
	end //initial
	
	initial begin
	
		reset <= 1;	a<=0;	b<=0;					@(posedge clk);
		reset <= 0;	a<=1;	b<=0;					@(posedge clk);
								b<=1;					@(posedge clk);
						a<=0;	b<=1;					@(posedge clk);
								b<=0;					@(posedge clk);
								b<=1;					@(posedge clk);
						a<=1;							@(posedge clk);
								b<=0;					@(posedge clk);
						a<=0;							@(posedge clk);
														@(posedge clk);

		$stop; //end simulation	
							
	end //initial

endmodule	
	
	
