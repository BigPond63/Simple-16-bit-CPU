`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.

Please enter your student ID:

*/

//module components_tb;
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
		
		// - Thought just do some test cases for each operation:
		// - ADD: 
		
		
		
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
	 

//endmodule




module components_tb;
    // TODO: Implement the logic of your testbench here


    // SIGN EXTENDER

    // Create I/O variables
    reg  [8:0]  data_se;
    wire [15:0] ext_output;

    // Instantiate Module
    sign_extend DUT_se (.in(data_se), .ext(ext_output));

    // Test case storage
    reg  [8:0]  test_se [0:3];
    reg  [15:0] exp_se  [0:3];

    // testbench statistics
    integer test_count_se = 0;
    integer errors_se = 0;
    reg done_se = 0;

    initial begin
        test_se[0] = 9'b100000000; // -256
        test_se[1] = 9'b011111111; // +255
        test_se[2] = 9'b000000000; // 0
        test_se[3] = 9'b111111111; // -1

        exp_se[0] = 16'b1111111100000000;
        exp_se[1] = 16'b0000000011111111;
        exp_se[2] = 16'b0000000000000000;
        exp_se[3] = 16'b1111111111111111;

        data_se = test_se[0];
    end

    always begin
        #10;
        if (test_count_se < 3) begin
            data_se = test_se[test_count_se + 1];
        end
    end

    always begin
        #9;
        if (test_count_se == 4 && !done_se) begin
            done_se = 1;

            if (errors_se == 0)
                $display("sign_extend: success");
            else
                $display("sign_extend: Number of Errors: %d", errors_se);
        end

        if (!done_se) begin
            if (ext_output !== exp_se[test_count_se]) begin
                $display(
                    "FAIL (sign_extend): input=%b, expected %b, but got %b",
                    test_se[test_count_se],
                    exp_se[test_count_se],
                    ext_output
                );
                errors_se = errors_se + 1;
            end
            #1;
            test_count_se = test_count_se + 1;
        end
    end


    // ALU

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



