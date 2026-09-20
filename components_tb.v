`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.

Please enter your student ID:

*/

module components_tb;
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
			
			- reset alone, confirm 0001 is the state
			- enable alone, confirm it cycles through all states
			- do reset and enable simultaneously
			- check illegal states
			- test with and without clock
				
				
		
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
	 
		- check each one goes to where it is suppose to go
		- check illegal selects
		- check that all other values are not changed when selecting 
	 
	 */
	 
	 
	 
	 
	 // ALU
		// ADD -> ripple carry adder
		
		// SUB -> ripple carry adder 
		
		
		// probably just increment values of a and b by 1 
		// A-B = 0
		// A-B = neg
		// A + B = overflow
		// 
		
	/*
		add
		- positive + positive check
		- overflow 
		sub 
		- what hapens wtih sub
		- negative result?
		- all zeros + all zeros
		- all ones + all ones
	*/
		
	/* registers
		- test who wins with rst and r_in
		- check with and without clk
	
	
	*/
	 

endmodule



module sign_ext_tb;
    // TODO: Implement the logic of your testbench here
	 
	 
	 // Create I/O variables
	 
	 // Sign Extender I/Os
	 reg [8:0] data;
	 wire [15:0] ext_output;
	 
	 
	 // Instantiate Module
	 
	 sign_extend DUT(.in(data), .ext(ext_output));
	 
	 
    // Test case storage
    reg  [8:0]  test [0:3];
    reg  [15:0] exp  [0:3];
 
    // create and initialize your testbench statistics
    integer test_count = 0;
    integer errors = 0;
 
    initial begin
        // Populate test cases
        test[0] = 9'b100000000; // only MSB is 1  -> most negative value (-256)
        test[1] = 9'b011111111; // only MSB is 0  -> most positive value (+255)
        test[2] = 9'b000000000; // all 0          -> zero
        test[3] = 9'b111111111; // all 1          -> -1
 
        // Corresponding expected 16-bit sign-extended values
        exp[0] = 16'b1111111100000000; // -256
        exp[1] = 16'b0000000011111111; // +255
        exp[2] = 16'b0000000000000000; // 0
        exp[3] = 16'b1111111111111111; // -1
 
        // Instantiate Input with first test case
        data = test[0];
    end
	 

    always begin
        #10;
        // move to the next test case
        if (test_count < 3) begin
            data = test[test_count + 1];
        end
    end

    always begin
        #9;
        if (test_count == 4) begin
            #10;
            /* Display that the code is finished,
               and state how many errors occurred. */

            if (errors == 0) begin
                $display("success");
                $stop;
            end
            else begin
                $display("Number of Errors: %d", errors);
            end

            // Stop the test bench
            $stop;
        end

        if (ext_output !== exp[test_count]) begin
            $display(
                "FAIL: input=%b, expected %b, but got %b",
                test[test_count],
                exp[test_count],
                ext_output
            );

            errors = errors + 1;
        end
        #1;
        // increment the test case count
        test_count = test_count + 1;
    end

endmodule

