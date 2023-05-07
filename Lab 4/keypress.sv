// Junhyoung Lee & Sangmin Lee
// 11/17/2022
// EE 271
// Lab #4
// This program is designed to have a game "Tug of War" into an electronic version

// keypress module treats a long press on the user input as one press

module keypress (clk, reset, leftkey, rightkey, leftpress, rightpress);

	input logic clk, reset, leftkey, rightkey;		// given input: 1-bit clk from CLOCK_50, 1-bit reset from user, 1-bit leftkey or rightkey from user
	output logic leftpress, rightpress;					// output: 1-bit leftpress or rightpress that is treated as one press even long press
	logic metaL, metaR;										// 1-bit logic: output from meta is logic for keypress used as metaL and metaR
	
	meta mL (.clk(clk), .reset(reset), .key(leftkey), .raw(metaL));
	meta mR (.clk(clk), .reset(reset), .key(rightkey), .raw(metaR));
	
	// consider long press as one press for left key
	enum {S0, S1} ps, ns;		// 1-bit of present state and next state
	
	// next state logic
	always_comb begin
		
		case (ps)
			
			// S0: initial state "off"
			S0:	if (metaL)	ns = S1;
					else			ns = S0;
			
			// S1: a state "on"
			S1:	if (metaL) 	ns = S1;
					else			ns = S0;
		
		endcase
	
	end
	
	assign leftpress = ((ps == S0) & metaL); 
	
	always_ff @(posedge clk) begin
	
		if (reset)
			ps <= S0;
		else
			ps <= ns;
	end
	
	// consider long press as one press for right key
	enum {S2, S3} ps1, ns1;		// 1-bit of present state and next state
	
	always_comb begin
		
		case (ps1)
			
			// S2: initial state "off"
			S2:	if (metaR)	ns1 = S3;
					else			ns1 = S2;
			
			// S3: a state "on"
			S3:	if (metaR) 	ns1 = S3;
					else			ns1 = S2;
		
		endcase
	
	end
	
	assign rightpress = ((ps1 == S2) & metaR);
	
	// sequential logic (DFFs)
	always_ff @(posedge clk) begin
	
		if (reset)
			ps1 <= S2;
		else
			ps1 <= ns1;
	end
		
endmodule


// This testbench creates combinations for reset and input leftkey and rightkey at positive edge of clk
module keypress_testbench ();

	logic clk, reset, leftkey, rightkey;	//input: 1-bit clk from CLOCK_50, 1-bit reset from user, 1-bit leftkey or rightkey from user
	logic leftpress, rightpress;				//output: 1-bit leftpress or rightpress that is treated as one press even long press
	
	keypress dut (.clk(clk), .reset(reset), .leftkey(leftkey), .rightkey(rightkey), .leftpress(leftpress), .rightpress(rightpress));
	
	//clock setup
	parameter clock_period = 100;
		
	initial begin
		clk <= 0;
		// every 50 period, the most divided clock is high and low
		forever #(clock_period /2) clk <= ~clk;		
	end //initial
		
	initial begin
	
		reset <= 1;						@(posedge clk);
		reset <= 0; leftkey<=0;		@(posedge clk);
											@(posedge clk);
						leftkey<=1;		@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
						leftkey<=0;		@(posedge clk);
											@(posedge clk);
						rightkey<=0;		@(posedge clk);
												@(posedge clk);
						rightkey<=1;		@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
						rightkey<=0;		@(posedge clk);
												@(posedge clk);
										
		$stop; //end simulation							
							
		end //initial

endmodule	