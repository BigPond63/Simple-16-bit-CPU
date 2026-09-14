`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.

Please enter your student ID:

*/

module components_tb.v;
    // TODO: Implement the logic of your testbench here
	 
	 /* SIGN EXTENDER
		// test the value against extended by 0 vs 1 
			-> check that it has extended MSB correctly
			
			test cases: (main)
				9'b100000000 -> only MSB is one
				9'b011111111 -> only MSB is 0
				9'b000000000 -> all 0
				9'b111111111 -> all 1
				reg signed [8:0] test;
				reg signed [15:0] exp;
	 
	 
	 */
	 
	 /* TICK FSM
	 
		test different state paths:
			- test with and without clk
			
			- enable cycle only
			- reset cycle only
			- test who wins -> enable resest
			
			- mix enable and rest cycle
				EEEE
				RRRR EEEE
				ERER EEEE
				RERE EEE 
				ERER EEEE
				RREE EE
				EERR EEEE
				 there's too many
				
				
		
		test illegal states:
			- 0000
			- 0011
			- 0110
			- 1100
			- 0111
			- 1110
			- 1111
	 
	 */
	 
	 /* MUX
	 
	 asdfsljdjaklsjd
	 
	 */
	 
	 
	 
	 
	 // ALU
		// ADD -> ripple carry adder
		// SUB -> ripple carry adder 
		
		
		// probably just increment values of a and b by 1 
		// A-B = 0
		// A-B = neg
		// A + B = overflow
		// 
		
	/* registers
		- test who wins with rst and r_in
		- check with and without clk
	
	
	*/
	 

endmodule