`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.

Please enter your student ID:
	36180521

*/


module fsm_tb(clk_fsm); // io be a flag to know when the next test bench should be done
	// REGISTERS SHOULD BE INPUTS
	// OUTPUTS SHOULD BE WIRES -> TO TEST
	
	input [0:0] clk_fsm;
	
	// initialise varaibles
	reg [0:0] rst_fsm;
	reg [0:0] en_fsm;

	wire [3:0] tick_fsm;
	
	reg [3:0] exp_initial;
	reg [3:0] exp_rst; //vectorsize];
	reg [3:0] exp_cycle [0:3];
	reg [3:0] illegal_state [0:11];
	reg [3:0] exp_clk_low;
	reg [3:0] exp_rst_en;
	reg [3:0] exp_rst_en_cycle [0:1];
	reg [3:0] exp_sequence [0:2];
	
	
	
	// instantiate module to test DUT
	tick_FSM DUT_fsm(
		.rst(rst_fsm),
		.clk(clk_fsm),
		.enable(en_fsm),
		.tick(tick_fsm)
	);
	
	integer errors_fsm, count_fsm;
	integer i;

	// initial inputs
	initial begin
		rst_fsm = 1'd0;
		en_fsm = 1'd0;
		
		exp_initial = 4'b0001;
		
		exp_rst = 4'b0001;
		
		
		exp_cycle[0] = 4'b0010;
		exp_cycle[1] = 4'b0100;
		exp_cycle[2] = 4'b1000;
		exp_cycle[3] = 4'b0001;
		
		// illegal states
		illegal_state[0] = 4'b0000; // all must return back to 0001
		illegal_state[1] = 4'b0011;
		illegal_state[2] = 4'b0101;
		illegal_state[3] = 4'b0110;
		illegal_state[4] = 4'b1001;
		illegal_state[5] = 4'b1010;
		illegal_state[6] = 4'b1100;
		illegal_state[7] = 4'b0111;
		illegal_state[8] = 4'b1011;
		illegal_state[9] = 4'b1101;
		illegal_state[10] = 4'b1110;
		illegal_state[11] = 4'b1111;
	
		
		// this one turns off the clock, make sure its on an off clk cycle
		exp_clk_low = 4'b0001; // en=1, clk=0, make sure doesnt' change stat with clock on
		
		exp_rst_en = 4'b0001;
		
		exp_rst_en_cycle[0] = 4'b0010;
		exp_rst_en_cycle[1] = 4'b0001;
		
		
		//E E R
		exp_sequence[0] = 4'b0010;
		exp_sequence[1] = 4'b0100;
		exp_sequence[2] = 4'b0001;
		
		
	end
	
	
	
	initial begin
		// tb statistics
		count_fsm = 32'd0;
		errors_fsm = 32'd0;
	end
	
	// test that fsm starts at the initial state

	
	always begin
		#9;
		
		if (count_fsm == 32'd25) begin
			#10;
			
			if (errors_fsm == 32'd0) $display("Success for fsm testbench!");
			$stop;
			
		end
		#1;
	end

		

	initial begin
		#8;
				// check initial fsm state
		if (tick_fsm !== exp_initial) begin
			$display("FAIL: initial state expected: %b, got %b",
				exp_initial, tick_fsm);
			$display(
			"WARNING: Future test cases will be affected by the dysfunctionality of the initial state"
			);
			
			errors_fsm = errors_fsm + 32'd1;
		end
			
		count_fsm = count_fsm + 32'd1;
		
		#2;
		

		// PREPARE FOR NEXT TEST (CYCLE)
		@(negedge clk_fsm) begin
			en_fsm = 1'd1;
			rst_fsm = 1'd0;
		end
		
		// check that enable works 
		// cycle enable states
		for (i=0; i<4; i=i+1) begin
			
			@(posedge clk_fsm) begin
				#2; // wait, to let fsm settle 
				if (tick_fsm !== exp_cycle[i]) begin
					$display("Cycle fail: State expected: %b, got %b",
						exp_cycle[i], tick_fsm);
					errors_fsm = errors_fsm + 32'd1;
				end
				
				count_fsm = count_fsm + 32'd1;
		
				end
			end
		
		// PREPARE FOR NEXT TEST (RST ONLY)
		@(negedge clk_fsm) begin
			en_fsm <= 1'd0;
			rst_fsm <= 1'd1;
		end
		
		@(posedge clk_fsm) begin
			#2 // wait for fsm to settle
			if (tick_fsm !== exp_rst) begin
				$display("Fail: Reset state expected: %b, got %b",
					exp_rst, tick_fsm);
				$display(
				"WARNING: Future test cases will be affected by the dysfunction of the reset"
				);
				errors_fsm = errors_fsm + 1;
			end
			
			count_fsm = count_fsm + 1;
		end
		
		// PREPARE FOR NEXT TEST (RST AND EN RACE CONDITION)
		@(negedge clk_fsm) begin
			en_fsm <= 1'd1;
			rst_fsm <= 1'd1;
		end
		
		@(posedge clk_fsm) begin
			#2
			if (tick_fsm !== exp_rst_en) begin
				$display("Reset enable race condition fail: State expected %b, got %b",
					4'b0001, tick_fsm);
				errors_fsm = errors_fsm + 32'd1;
			end
			
			count_fsm = count_fsm + 32'd1;
		
		end
		
		// RESET BACK TO INITIAL STATE
		@(negedge clk_fsm) begin
			en_fsm <= 1'd0;
			rst_fsm <= 1'd1;
		end
		
		// PREPARE FOR NEXT TEST (ER)
		@(posedge clk_fsm) begin
			#2;
			en_fsm <= 1'd1;
			rst_fsm <= 1'd0;
			
		end
		
		
		
		for (i = 0; i<2; i=i+1) begin
			// reset
			if (i==1) begin
				en_fsm = 1'd0;
				rst_fsm = 1'd1;
			end
			
			@(posedge clk_fsm) begin
				#2;
				if (tick_fsm !== exp_rst_en_cycle[i]) begin
					$display("Half cycle reset fail: State expected %b, got %b",
						exp_rst_en_cycle[i], tick_fsm);
					errors_fsm = errors_fsm + 32'd1;
				end
				
				count_fsm = count_fsm + 32'd1;
			end
			
		end
		
		
		// RESET CYCLE FOR NEXT TEST
		@(negedge clk_fsm) begin
			en_fsm <= 1'd0;
			rst_fsm <= 1'd1;
		end
		
		@(posedge clk_fsm) #2 rst_fsm <= 1'd0;
		
		// SET UP VARIABLES FOR NEXT CLOCK CYCLE
		@(negedge clk_fsm) begin
			en_fsm <= 1'd1;
			rst_fsm <= 1'd0;
		end
		
		for (i=0; i<3; i=i+1) begin
			// reset midway
			if (i==2) begin
				en_fsm <= 1'd0;
				rst_fsm <= 1'd1;
			end
			
			@(posedge clk_fsm) begin
				#2;
				if (tick_fsm !== exp_sequence[i]) begin
					$display("Sequence reset fail: State expected %b, got %b",
						exp_sequence[i], tick_fsm);
					errors_fsm = errors_fsm + 1;
				end
				
				count_fsm = count_fsm + 1;
			
			end
			
		end
		
	// set variables to reset fsm back to initial state
	@(negedge clk_fsm) begin
		en_fsm <= 1'd0;
		rst_fsm <= 1'd1;
	end
	
	// set up variables for next tb (en=1, without clock)
	@(posedge clk_fsm) begin
		#2;
		en_fsm <= 1'd1;
		rst_fsm <=1'd0;
	end
		
	// test EN ON WITHOUT CLOCK
	
	@(negedge clk_fsm) begin
		#2;
		
		if (tick_fsm !== exp_clk_low) begin
			$display("Clock input low fail: State expected: %b, got %b",
				4'b0001, tick_fsm);
			errors_fsm = errors_fsm + 1;
		end
		
		count_fsm = count_fsm + 1;
		
	end
	
	// RESET TO INITIAL STATE
	@(negedge clk_fsm) begin
		rst_fsm <= 1'd1;
		en_fsm <= 1'd0;
	end
		
	// SET UP VARIABLES FOR NEXT TB (ILLEGAL STATES)
	@(posedge clk_fsm) begin
		#2;
		en_fsm <= 1'd1;
		rst_fsm <= 1'd0;
	end
	
	for (i=0; i<12; i=i+1) begin
		// hierarchal assignment
		@(negedge clk_fsm) DUT_fsm.tick_reg = illegal_state[i];
		
		@(posedge clk_fsm) begin
			#2;
			if (tick_fsm !== 4'b0001) begin
				$display("Illegal state recovery fail: State expected: %b, got %b",
					4'b0001, tick_fsm);
				errors_fsm = errors_fsm + 1;
			end
			
			count_fsm = count_fsm + 1;
		end
		
	end
		
		
	end
		
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
		

	
	

module register_tb(clk_reg);

	parameter Z=16;
	
	//io
	input [0:0] clk_reg;
	
	reg [Z-1:0] din_reg;
	reg [0:0] rin_reg;
	reg [0:0] rst_reg;
	
	wire [Z-1:0] output_reg;
	wire [31:0] error_value;
	
	
	reg [Z-1:0] exp_cur;
	reg [Z-1:0] exp_initial;
	reg [Z-1:0] exp_rin_value;
	
	
	
	
	// instantiate module to be tested
	register_n #(.N(Z)) DUT_reg (
	.data_in(din_reg),
	.r_in(rin_reg),
	.clk(clk_reg),
	.Q(output_reg),
	.rst(rst_reg)
	);
	
	// instantiate checker module
	register_tb_checker #(.A(Z)) initial_reg_check (
		.reg_value(output_reg),
		.exp_reg(exp_cur),
		.error_reg(error_value)
		);
	
	integer count_reg, errors_reg;
	
	// initialise values
	initial begin
		count_reg = 32'd0;
		errors_reg = 32'd0;
		
		din_reg = {Z{1'd1}}; // set as all ones so that it checks the initial state is working
		rin_reg = 1'd0;
		rst_reg = 1'd0;
		
		exp_initial = {Z{1'd0}};
		exp_rin_value = {Z{1'd1}};
	end
	
	// test initial state
	
	
	// test r_in works
	
	// test rst works
	
	// load up a value in datain, and test the race condition with r_in and rst
	
	// load up a value with r_in, then check that when clk is off no change should occur to the value
		// do one with rst
		// do one with enable
		
		
		
	always begin
	#9;
		if (count_reg == 32'd4) begin
			#10;
			
			if (errors_reg == 32'd0) $display("Success for register TB!");
			forever #1;
			
		end
	
	#1;
	
	end
	
	initial begin
		#5; // safety
		exp_cur = exp_initial;
		// test initial state, have din differ from initial state to ensure that it does not change
		
		
		@(posedge clk_reg) begin
			#2;
			count_reg <= count_reg + 32'd1;
			
			if (error_value == 32'd1) begin
				errors_reg <= errors_reg + error_value;
				$display("Register Error: Expected %b, got: %b",
					exp_cur, output_reg);
			end
		end
		
		// test r_in works
		
		// setup variable for next test
		@(negedge clk_reg) begin
			rin_reg = 1'd1;
			exp_cur <= exp_rin_value;
		end
		
		@(posedge clk_reg) begin
			#2;
			count_reg <= count_reg + 32'd1;
			
			if (error_value == 32'd1) begin
				$display("Register Error: Expected %b, got: %b",
					exp_cur, output_reg);
				errors_reg <= errors_reg + error_value;
			end
		end
		
		// datain value, test race b/w rst and en
		
		// force hierarchal assignment
		@(negedge clk_reg) begin
			DUT_reg.Q_reg <= {Z{1'd1}}; // force output Q_reg to be that value
			rst_reg <= 1'd1;
			rin_reg <= 1'd1;
			exp_cur <= {Z{1'b0}};
		end
		
		@(posedge clk_reg) begin
			#2
			count_reg <= count_reg + 32'd1;
			
			if (error_value == 32'd1) begin
				$display("Register Error: Expected %b, got: %b",
					exp_cur, output_reg);
				errors_reg <= errors_reg + error_value;
			end
			
		end
		
		// reset variables and prepare for next test case
		@(negedge clk_reg) begin

					DUT_reg.Q_reg <= {Z{1'd1}};
					exp_cur <= {Z{1'd1}};
					rst_reg <= 1'd1;
					rin_reg <= 1'd1;
	
			end
	
			#2;
			// do test case without clock;
			count_reg <= count_reg + 32'd1;

			if (error_value == 32'd1) begin
				$display("Register Error: Expected %b, got: %b",
					exp_cur, output_reg);
				errors_reg <= errors_reg + error_value;
			end
			
		end

	
endmodule

module register_tb_checker(reg_value, exp_reg, error_reg);
	parameter A = 16; // default is 16, but can be overridded to be equated to Z
	
	input [A-1:0] reg_value;
	input [A-1:0] exp_reg;
	output reg [31:0] error_reg;
	
	always @(*) begin
		if (reg_value !== exp_reg) begin
			error_reg = 32'd1;
		end else error_reg = 32'd0;
	
	end
	
endmodule



module components_tb;
	reg [0:0] clk_tb = 1'd0;
	
	initial begin
	#12;
		forever #5 clk_tb = ~clk_tb;
	end

	fsm_tb my_tb(.clk_fsm(clk_tb));
	register_tb #(.Z(16)) my_reg(.clk_reg(clk_tb));


	
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

            // Stop the test bench, idle
            forever #1;
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
	 
	 
	 
	 
	 	 
	 //MULTIPLEXER
	 
	 // Create I/O variables
	 
	 reg  [15:0] R0_mux, R1_mux, R2_mux, R3_mux, R4_mux, R5_mux, R6_mux, R7_mux;
	 reg  [15:0] G_mux;	
	 reg  [15:0] SignExtDin_mux;
	 reg  [3:0]  sel_mux;
	 wire [15:0] Bus_mux;
	 
	 
	 
	 
	 // Instantiate Module
	 
	 
	 multiplexer DUT_mul (.SignExtDin(SignExtDin_mux), .R0(R0_mux), .R1(R1_mux), .R2(R2_mux), .R3(R3_mux), .R4(R4_mux), .R5(R5_mux), .R6(R6_mux), .R7(R7_mux), .G(G_mux), .sel(sel_mux), .Bus(Bus_mux));
	 
	 
	 // Create placeholder values for each input into multiplexer:
	 
	 reg [15:0] exp_mux [0:15];
	 
	 
	 // Load values:
	 
	 initial begin    
		 R0_mux = 16'd1; R1_mux = 16'd2; R2_mux = 16'd3; R3_mux = 16'd4;
		 R4_mux = 16'd5; R5_mux = 16'd6; R6_mux = 16'd7; R7_mux = 16'd8;
		 G_mux  = 16'd9; SignExtDin_mux = 16'd10;
		 
		 exp_mux[0]=R0_mux; exp_mux[1]=R1_mux; exp_mux[2]=R2_mux; exp_mux[3]=R3_mux;
		 exp_mux[4]=R4_mux; exp_mux[5]=R5_mux; exp_mux[6]=R6_mux; exp_mux[7]=R7_mux;
		 exp_mux[8]=G_mux;  exp_mux[9]=SignExtDin_mux;
		 
		 // illegal input lines
		 exp_mux[10]=16'd0; exp_mux[11]=16'd0; exp_mux[12]=16'd0; 
		 exp_mux[13]=16'd0; exp_mux[14]=16'd0; exp_mux[15]=16'd0; 
		 
		 sel_mux = 4'b0000;
end		 

	 
	 
	 // Testbench Statistics
	 
	 integer test_count_mux = 0;
	 integer errors_mux = 0;
	 reg done_mux = 0;
	 
	 
	 
    always begin
        #10;
        if (test_count_mux < 15) begin
            sel_mux = sel_mux + 1;
        end
    end


    always begin
        #9;
        if (test_count_mux == 16 && !done_mux) begin
            done_mux = 1;
            if (errors_mux == 0)
                $display("MUX: success");
            else
                $display("MUX: Number of Errors: %d", errors_mux);
        end

        if (!done_mux) begin
            if (Bus_mux !== exp_mux[test_count_mux]) begin
                $display(
                    "FAIL (MUX): sel=%h, expected %h, but got %h",
                    sel_mux,
                    exp_mux[test_count_mux],
                    Bus_mux
                );
                errors_mux = errors_mux + 1;
            end
            #1;
            test_count_mux = test_count_mux + 1;
        end
    end
	 
	 
	 // End simulation when done flags are 1
    always begin
        #1;
        if (done_se && done_alu && done_mux && done_reg && done_fsm) begin
            $display("All testbenches complete.");
            forever #1; // idle until all test done with flag
        end
    end
	 
	 

	 
	 
	 
endmodule
