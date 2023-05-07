// Junhyoung Lee & Sangmin Lee
// 10/14/2022
// EE 271
// Lab #1
// This program adds given two number and shows the result with number of LEDs in binary

// fullAdder4 module adds two of 4-bit numbers and outcome of the summ is either 4-bit or 5-bits number

module fullAdder4 (A, B, cin, sum, cout);

	input logic [3:0] A;			// given input: 4-bits number
	input logic [3:0] B;			// given input: 4-bits number
	input logic cin;				// given input: 1-bit number
	
	output logic [3:0] sum;		// outcome: 4-bits number
	output logic cout;			// outcome: 1-bits number
	
	logic c0;	// cout of first digit of two binary number sum A and B
	logic c1;	// cout of second digit of two binary number sum A and B
	logic c2;	// cout of third digit of two binary number sum A and B
	
	fullAdder FA0 (.A(A[0]), .B(B[0]), .cin(cin), .sum(sum[0]), .cout(c0));
	fullAdder FA1 (.A(A[1]), .B(B[1]), .cin(c0), .sum(sum[1]), .cout(c1));
	fullAdder FA2 (.A(A[2]), .B(B[2]), .cin(c1), .sum(sum[2]), .cout(c2));
	fullAdder FA3 (.A(A[3]), .B(B[3]), .cin(c2), .sum(sum[3]), .cout(cout));

endmodule


module fullAdder4_testbench();

	logic [3:0] A;
	logic [3:0] B;
	logic cin;
	
	logic [3:0] sum;
	logic cout;

	fullAdder4 dut (.A(A), .B(B), .cin(cin), .sum(sum), .cout(cout));
	
	integer i;
	
	initial begin
	
		for (i=0; i<2**9; i++) begin
		
			{A, B, cin} = i; #10;	// create all the posiible cases (2^9) of combination of A, B and cin
			
		end
		
	end
	
endmodule	