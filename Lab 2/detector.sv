// Junhyoung Lee & Sangmin Lee
// 10/21/2022
// EE 271
// Lab #2 Task 3 (Extra Credit)
// This program detect a item given with secret mark and tell us whether it is discounted and whether it is stolen

// detector module shows whether an item given by upc code was sold at a discounted price and whether an item is stolen

module detector (u, p, c, M, Dis, St);
	
	input logic u, p, c, M;			// given input: upc number of item, a secret mark by detector
	output logic Dis, St;			// outcome: whether it is discounted and whether it is stolen
	
	assign Dis = p | (u & c);
	assign St = (~p & ~c & ~M) | (u & c & ~M);
	
endmodule

// This testbench create all possible combinations (2^4) of 4 inputs (u, p, c, M)
// Also include the combinatiuons that does not defined with item number UPC (don't cares)
// By the testbench, it is possible to check whether there is correct output by simulating on ModelSim
module detector_testbench ();

	logic u, p, c, M, Dis, St;		// input: u, p, c, M		// output: Dis, St
	
	detector dut (u, p, c, M, Dis, St);
	
	integer i;
		
	initial begin
		
		for (i=0; i<2**4; i++) begin
			
			{u, p, c, M} = i; #10;

		end
		
	end
		
endmodule	