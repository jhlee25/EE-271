// Junhyoung Lee & Sangmin Lee
// 10/14/2022
// EE 271
// Lab #1
// This program adds given two number and shows the result with number of LEDs in binary

// fullAdder module adds two of 1-bit numbers and outcome of the summ is either 1-bit or 2-bits number

module fullAdder (A, B, cin, sum, cout);

	input logic A, B, cin;				// given: 1-bit A, B, and cin
	output logic sum, cout;				// outcome: 1-bit sum and 1-bit cout
	
	assign sum = A ^ B ^ cin;			// A XOR B XOR C
	assign cout = A&B | cin & (A^B);	// (A and B) OR cin AND (A XOR B)
	
endmodule

module fullAdder_testbench();

	logic A, B, cin, sum, cout;
	
	fullAdder dut (A, B, cin, sum, cout);
	
	integer i;
	initial begin
	
		for(i=0; i<2**3; i++) begin  // create all the posiible cases (2^3) of combination of A, B and cin
			{A, B, cin} = i; #10;
		end
	
	end
	
	
endmodule	