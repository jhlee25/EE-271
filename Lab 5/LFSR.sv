// Junhyoung Lee & Sangmin Lee
// 12/06/2022
// EE 271
// Lab #5
// This program is designed to have a game "Tug of War" into an electronic version with computer opponent to play against

// LFSR module generate a random number to simulate the button press

module LFSR (clk, reset, out);

	input logic clk, reset;			// given input: 1-bit clk from divided clock, 1-bit reset from user
	output logic [9:0] out;			// output: 10-bit out representing LFSR
	
	// sequential logic (DFFs)
	always_ff @ (posedge clk)
		begin
			if (reset)
				out <= 10'b0000000000;
			else
				begin
					out <= out >> 1;
					out[9] <= ~(out[0] ^ out[3]);
				end
		end
		
endmodule


module LFSR_testbench ();

	logic clk, reset;		// given input: 1-bit clk from divided clock, 1-bit reset from user
	logic [9:0] out;		// output: 10-bit out representing LFSR
	
	LFSR dut (.clk(clk), .reset(reset), .out(out));
	
	//clock setup
	parameter clock_period = 100;
		
	initial begin
		clk <= 0;
		// every 50 period, the most divided clock is high and low
		forever #(clock_period /2) clk <= ~clk;		
	end //initial
	
	initial begin
	
		reset <= 1;			@(posedge clk);
		reset <= 0;			@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
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