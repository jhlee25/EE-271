// Junhyoung Lee & Sangmin Lee
// 12/06/2022
// EE 271
// Lab #5
// This program is designed to have a game "Tug of War" into an electronic version with computer opponent to play against

// meta module makes raw input from user as synchronized to have metastability treatment

module meta (clk, reset, key, raw);

	input logic clk, reset, key;	// given input: 1-bit clk from divided clock, 1-bit reset from user, 1-bit key from user
	output logic raw;					// output: 1-bit raw key that is synchronized
	
	logic tmp;							// logic: 1-bit temporary logic used for metastability treatment
	
	// sequential logic (DFFs)		// metastability treatment
	always_ff @(posedge clk) begin
		
		if (reset)			// when reset is pressed, the tmp and raw are both 0
			begin
				tmp <= 0;
				raw <= 0;
			end
		else begin			// when reset is not pressed, tmp stores key and raw stores the tmp
				tmp <= key;	// this is the metastability that synchronize the inout
				raw <= tmp;
		end
	end

endmodule


// This testbench creates combinations for reset and input key at positive edge of clk
module meta_testbench ();

	logic clk, reset, key;		// input: 1-bit clk from divided clock, 1-bit reset from user, 1-bit key from user
	logic raw;						// output: 1-bit raw key that is synchronized
	
	meta dut (.clk(clk), .reset(reset), .key(key), .raw(raw));
	
	//clock setup
	parameter clock_period = 100;
		
	initial begin
		clk <= 0;
		// every 50 period, the most divided clock is high and low
		forever #(clock_period /2) clk <= ~clk;		
	end //initial
		
	initial begin
	
		reset <= 1;					@(posedge clk);
		reset <= 0; key<=0;		@(posedge clk);
										@(posedge clk);
						key<=1;		@(posedge clk);
										@(posedge clk);
						key<=0;		@(posedge clk);
										@(posedge clk);
						key<=1;		@(posedge clk);
										@(posedge clk);
						key<=0;		@(posedge clk);
										@(posedge clk);
						key<=1;		@(posedge clk);
										@(posedge clk);
										@(posedge clk);
										
		$stop; //end simulation							
							
		end //initial
		
endmodule	