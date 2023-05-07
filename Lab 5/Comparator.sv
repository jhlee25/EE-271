// Junhyoung Lee & Sangmin Lee
// 12/06/2022
// EE 271
// Lab #5
// This program is designed to have a game "Tug of War" into an electronic version with computer opponent to play against

//	Comparator module compares the two values from LFSR and SW

module Comparator (A, B, out);

	input logic [9:0] A, B;			// given input: 10-bit input A and B which are used to compare
	output logic out;					// output: 1-bit output (1 for A > B, 0 for else)
	
	always_comb begin
		
		if (A > B)						// A: SW, B: LFSR
			out <= 1'b1;
		else
			out <= 1'b0;
		
	end

endmodule


module Comparator_testbench ();

	logic [9:0] A, B;				// given input: 10-bit input A and B which are used to compare
	logic out;						// output: 1-bit output (1 for A > B, 0 for else)
	
	Comparator dut (.A(A), .B(B), .out(out));
	
	integer i;
	initial begin
	
		for(i=0; i<2**3; i++) begin  // create all the posiible cases (2^3) of combination of A, B
			{A, B} = i; #10;
		end
	
	end
	
endmodule	