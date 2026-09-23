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



module components_tb;
	/* ----------------------------------- 
				SIGN EXTENDER
	-------------------------------------*/
	

    // TODO: Implement the logic of your testbench here
	 
	 
	 // Create I/O variables
	 
	 // Sign Extender I/Os
	 reg [8:0] data_se;
	 wire [15:0] ext_output;
	 
	 
	 
	 // Instantiate Module
	 
	 sign_extend DUT_ext(
		.in(data_se),
		.ext(ext_output)
		);
	 
	 
    // Test case storage
    reg  [8:0]  test_se [0:3];
    reg  [15:0] exp_se  [0:3];
 
    // create and initialize your testbench statistics
    integer test_count_se = 0;
    integer errors_se = 0;
	 reg done_se = 0;
 
    initial begin
        // Populate test cases
        test_se[0] = 9'b100000000; // only MSB is 1  -> most negative value (-256)
        test_se[1] = 9'b011111111; // only MSB is 0  -> most positive value (+255)
        test_se[2] = 9'b000000000; // all 0          -> zero
        test_se[3] = 9'b111111111; // all 1          -> -1
 
        // Corresponding expected 16-bit sign-extended values
        exp_se[0] = 16'b1111111100000000; // -256
        exp_se[1] = 16'b0000000011111111; // +255
        exp_se[2] = 16'b0000000000000000; // 0
        exp_se[3] = 16'b1111111111111111; // -1
 
        // Instantiate Input with first test case
        data_se = test_se[0];
    end
	 

    always begin
        #10;
        // move to the next test case
        if (test_count_se < 3) begin
            data_se = test_se[test_count_se + 1]; 
        end
    end

    always begin
        #9;
        if (test_count_se == 4) begin
            #10;
            /* Display that the code is finished,
               and state how many errors occurred. */

            if (errors_se == 0) begin
                $display("success");
            end
            else begin
                $display("Number of Errors: %d", errors_se);
            end

            // Stop the test bench
            $stop;
        end

        if (ext_output !== exp_se[test_count_se]) begin
            $display(
                "FAIL: input=%b, expected %b, but got %b",
                test_se[test_count_se],
                exp_se[test_count_se],
                ext_output
            );

            errors_se = errors_se + 1;
        end
        #1;
        // increment the test case count
        test_count_se = test_count_se + 1;
    end
	 
	 
    
	/* ----------------------------------- 
				ALU
	-------------------------------------*/

    // Create I/O variables
    reg  [15:0] input_a_alu;
    reg  [15:0]  input_b_alu;
    reg [2:0] op_code_alu;
	 wire [15:0] result_alu;
		
		
	// Instantiate Module

		ALU DUT_alu (.input_a(input_a_alu), .input_b(input_b_alu), .alu_op(op_code_alu), .result(result_alu));

    // Create test cases storages
	 
	 reg [15:0] test_a_alu [0:9];
	 reg [15:0] test_b_alu [0:9];
	 reg [2:0] test_op_alu [0:9];
	 reg [15:0] exp_alu [0:9];
	 
	 
	 // Testbench statistics
		
	 integer test_count_alu = 0;
	 integer errors_alu = 0;
	 reg done_alu = 0;
	 
	 // Load the expected values from inputs into test cases

		 initial begin
		  test_a_alu[0]=16'd6;    test_b_alu[0]=16'd7;    test_op_alu[0]=3'b000; exp_alu[0]=16'd42;    // multiply: basic
		  test_a_alu[1]=16'd1000; test_b_alu[1]=16'd1000; test_op_alu[1]=3'b000; exp_alu[1]=16'h4240;  // multiply: overflow
		  test_a_alu[2]=16'd100;  test_b_alu[2]=16'd25;   test_op_alu[2]=3'b001; exp_alu[2]=16'd125;   // add: basic
		  test_a_alu[3]=16'd32767;test_b_alu[3]=16'd1;    test_op_alu[3]=3'b001; exp_alu[3]=16'h8000;  // add: overflow
		  test_a_alu[4]=16'd50;   test_b_alu[4]=16'd20;   test_op_alu[4]=3'b010; exp_alu[4]=16'd30;    // subtract: basic
		  test_a_alu[5]=16'd5;    test_b_alu[5]=16'd10;   test_op_alu[5]=3'b010; exp_alu[5]=16'hFFFB;  // subtract: negative result
		  test_a_alu[6]=16'd2;    test_b_alu[6]=16'd6;    test_op_alu[6]=3'b011; exp_alu[6]=16'd24;    // shift: left
		  test_a_alu[7]=-16'd1;   test_b_alu[7]=-16'd6;   test_op_alu[7]=3'b011; exp_alu[7]=16'hFFFD;  // shift: signed right
		  test_a_alu[8]=16'd1;    test_b_alu[8]=16'd1;    test_op_alu[8]=3'b101; exp_alu[8]=16'h0000;  // don't-care opcode
		  test_a_alu[9]=-16'd1;   test_b_alu[9]=-16'd1;   test_op_alu[9]=3'b001; exp_alu[9]=16'hFFFE;  // add: negative operands
 
		  // Load first test case
		  input_a_alu = test_a_alu[0];
		  input_b_alu = test_b_alu[0];
		  op_code_alu  = test_op_alu[0];
	 end
	 

	 always begin
		  #10;
		  if (test_count_alu < 9) begin
				input_a_alu = test_a_alu[test_count_alu + 1];
				input_b_alu = test_b_alu[test_count_alu + 1];
				op_code_alu  = test_op_alu[test_count_alu + 1];
		  end
	 end
	 
	 
	 
	 always begin
		  #9;
		  if (test_count_alu == 10 && !done_alu) begin
				done_alu = 1;
				if (errors_alu == 0)
					 $display("ALU: success");
				else
					 $display("ALU: Number of Errors: %d", errors_alu);
		  end
 
		  if (!done_alu) begin
				if (result_alu !== exp_alu[test_count_alu]) begin
					 $display(
						  "FAIL (ALU): a=%h, b=%h, op=%b, expected %h, but got %h",
						  test_a_alu[test_count_alu],
						  test_b_alu[test_count_alu],
						  test_op_alu[test_count_alu],
						  exp_alu[test_count_alu],
						  result_alu
					 );
					 errors_alu = errors_alu + 1;
				end
				#1;
				test_count_alu = test_count_alu + 1;
		  end
	 end	 
	 
	 // End simulation when done flags are 1
    always begin
        #1;
        if (done_se && done_alu) begin
            $display("All testbenches complete.");
            $stop;
        end
    end

endmodule
