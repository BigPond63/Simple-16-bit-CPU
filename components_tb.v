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
			
			- reset alone, confirm 0001 is the state (check each time), reset from all states 
			- enable alone, confirm it cycles through all states (wraparound too)
			- do reset and enable simultaneously -> rst should win, check all states 
			- check illegal states
			- test with and without clock 
				- en -> 0, clk =1
				
				
		
		test illegal states:
			- 0000
			- 0011
			- 0110
			- 1100
			- 0111
			- 1110
			- 1111
	 
	 */
	 
endmodule

module fsm_tb;
	// REGISTERS SHOULD BE INPUTS
	// OUTPUTS SHOULD BE WIRES -> TO TEST
	
	// initialise varaibles
	reg [0:0] rst_fsm;
	reg [0:0] clk_fsm;
	reg [0:0] en_fsm;

	wire [3:0] tick_fsm;
	
	reg [3:0] exp [0:0]; //vectorsize];
	
	
	// instantiate module to test DUT
	tick_FSM DUT_fsm(
		.rst(rst_fsm),
		.clock(clk_fsm),
		.enable(en_fsm),
		.tick(tick_fsm)
	);
	

	// initial inputs
	initial begin
		rst_fsm = 1'd0;
		clk_fsm = 1'd0;
		en_fsm = 1'd0;
	end
	
	
	// increment loop
	always begin
		#12
		
		forever begin
			#5
			clk_fsm = ~clk_fsm;
		end
		
	end
	
	// test that reset works
	
	// test all enable , cycling states
	// alternating patterns
	// special cases
		// en and rst together
	// no clk, en
	// test illegal states -> must fall to 0001
	
	
	// create tb stats
	
	
	// test the DUT and do counter/ erro checking etc.
	
	/*
	each separate test case do a for loop
	
	first - test that reset works, so state should be 0001 -> make sure to make other test cases useable
	all enable - use a 'for' loop to cycle through each state and check its expected output (<5)
	
	these test cases will only pass if the previous first two conditions have passed -> bit-burst error,
	consequence of one part of the alogrithm not working will influence the other parts to fail as well
	
	test alternating patterns - test each output after each En/rst, see if it p=matches the expected
		synchronise it with the clock, have to hardcode this into verilog code, ie #10; en_fsm = 1 on clock 
	
	test illegal states - check that the default command to 0001 is working as expected
		- although this cannot appear due to the logic of the program we still need to see that default case statements 
			are safely handled in the fsm
		- 1111, 0000, 0110, 1100, 0011 (multiple states at once, or no states)
	*/
	
	
	 
	 
endmodule
	 
	 /* MUX
	 
		- check each one goes to where it is suppose to go
		- check illegal selects
		- check that all other values are not changed when selecting 
	 
	 */
	 
	 

module alu_tb;
	// io
	reg [15:0] input_a_test;
	reg [15:0] input_b_test;
	reg [2:0] alu_op_test;
	wire [15:0] result_alu_test;
	
	
	// instantiate module
	ALU DUT_alu (
		.input_a(input_a_test),
		.input_b(input_b_test),
		.alu_op(alu_op_test),
		.result(result_alu_test)
	);
	
	initial begin
		// initial values of inputs
	
	end
	 
	 // ALU
		// ADD -> ripple carry adder no
		
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
		

	 

endmodule


module register_tb;
	//io
	reg [15:0] din_reg;
	reg [0:0] rin_reg;
	reg [0:0] clk_reg;
	wire [15:0] output_reg;
	reg [0:0] rst_reg;
	
	
	
	// instantiate module to be tested
	register_n #(.N(16)) DUT_reg (
	.data_in(din_reg),
	.r_in(rin_reg),
	.clk(clk_reg),
	.Q(output_reg),
	.rst(rst_reg)
	);
	
	/* registers
		- test who wins with rst and r_in
		- check with and without clk
		
		workflow to be done:
			- with specific input ie. {N{1'b1}};
			
		test cases:
			- first, verify that as r_in is active that the data actually goes input the output_reg
			- second, verify that rst works and output should be all zeros once done
			- third, check that when rst and r_in are both active, who wins? (rst, should win)
			- check that when r_in is on, and clk is off, output should not change (keep state as {N{1'b1}}
	*/
	
	
endmodule


module sign_ext_tb;
    // TODO: Implement the logic of your testbench here
	 
	 
	 // Create I/O variables
	 
	 // Sign Extender I/Os
	 reg [8:0] data;
	 wire [15:0] ext_output;
	 
	 
	 
	 // Instantiate Module
	 
	 sign_extend DUT_ext(
		.in(data),
		.ext(ext_output)
		);
	 
	 
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
                $stop; // fox
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
