// Junhyoung Lee & Sangmin Lee
// 12/11/2022
// EE 271
// Lab #6
// This program shows number of cars in the parkinglot with photosensors that detects activity of a car

// upcount module is designed to have a binary value increases by 1 and up to 7

module counter #(parameter width = 3) (out, inc, dec, reset, clk);

	output logic [width-1:0] out;				// output: 3-bit out representing binary value increases ore decreases by 1
	input logic inc, dec;						// given input: 1-bit increment for counter, 1-bit decrement for counter
	input logic reset, clk;						// given input: 1-bit reset from user, 1-bit clk from CLOCK_50
	
	// sequential logic (DFFs)
	always_ff @(posedge clk)
		
		begin
			
			if (reset)
				out <= 0;
			else if (inc)				// If increment is true, the output increases by 1
				out <= out + 1;
			else if (dec)				// If decrement is true, the output decreases by 1
				out <= out - 1;
				
		end

endmodule


module counter_testbench ();

	parameter width = 3;
	logic [width-1:0] out;				// output: 3-bit out representing binary value increases by 1
	logic inc, dec;						// given input: 1-bit increment for counter, 1-bit decrement for counter
	logic reset, clk;						// given input: 1-bit reset from user, 1-bit clk from CLOCK_50
	
	counter dut (.out(out), .inc(inc), .dec(dec), .reset(reset), .clk(clk));
	
	//clock setup
	parameter clock_period = 100;
		
	initial begin
		clk <= 0;
		// every 50 period, the most divided clock is high and low
		forever #(clock_period /2) clk <= ~clk;		
	end //initial
	
	initial begin
	
		reset <= 1;					@(posedge clk);	// out = 0
		reset <= 0;	inc<=1;		@(posedge clk);	// out = 0
						inc<=0;		@(posedge clk);	// out = 1
						inc<=1;		@(posedge clk);	// out = 1
						inc<=0;		@(posedge clk);	// out = 2
						inc<=1;		@(posedge clk);	// out = 2
						inc<=1;		@(posedge clk);	// out = 3
						inc<=1;		@(posedge clk);	// out = 4
						inc<=1;		@(posedge clk);	// out = 5
						inc<=0;		@(posedge clk);	// out = 6
						inc<=0;		@(posedge clk);	// out = 6
						inc<=0;		@(posedge clk);	// out = 6
						inc<=1;		@(posedge clk);	// out = 6
						inc<=1;		@(posedge clk);	// out = 7
						
						dec<=1;		@(posedge clk);	// out = 7
						dec<=0;		@(posedge clk);	// out = 6
						dec<=1;		@(posedge clk);	// out = 6
						dec<=1;		@(posedge clk);	// out = 5
						dec<=1;		@(posedge clk);	// out = 4
						dec<=1;		@(posedge clk);	// out = 3
						dec<=0;		@(posedge clk);	// out = 3
						dec<=0;		@(posedge clk);	// out = 3
						dec<=0;		@(posedge clk);	// out = 3
						dec<=1;		@(posedge clk);	// out = 3
						dec<=1;		@(posedge clk);	// out = 2
						dec<=1;		@(posedge clk);	// out = 1
	
		$stop; //end simulation	
							
	end //initial
	
endmodule	