`timescale 1ns/1ps
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the processor.

Please enter your student ID:

*/
module proc_tb;
    // TODO: Implement the logic of your testbench here
	 
	 // movi
	 // add
	 // addi
	 // sub
	 
	 // how do we check the functionality of the processor?
	 // check how the components interact with each other and make sure that they are correct
		// check ticks for each instruction, and what it is suppose to produce per tick, which what register changes
	// reset input of the processor should be synchronous, so once an input has been done -> test that all registers are emptied
		// load value into all registers? -> thoroughly checks reset, but also fsm go back to initial 
	
	/*
	initial processor state -> everything 0, fsm at 0001
	
	*/
	
	/*
	task blocks
	-> final task blcok which can be used to check a singular instruciton to its register io 
		// only check select register, not any other bc tbf they are irrelevant
	
	-> mix multiple instrucitons together?
		// inputs could be 3 instructions -> 6 total inputs (each instr takes two space)
		// clk edge will do the instructions sequentially and checks can be done at each stage
		
		// can try make an algorithm that will say what value each reg should be with seuqential move order, parameter?
			// 
	*/
	
	/* Actual tasks to be done
	
	- initial state
	- reset
	- add
		- pos + pos simple
		- from a pos + (neg)
		- neg + neg
		
		- must test edge cases
		- from the max value, plus a certain number what happens
		- from min value, what happens if we add? -> wrap around?
		
		
	- sub
		- pos - pos
		- pos - neg
		- neg - pos
		- neg - neg
		
		- largest value ->sub -1?
		- smallest value -> sub 1?
	- movi
		- max value
		- smallest value
		- immedaite given during tick 3?
		- given at tick 4?
		
	- addi
		- immediate value given during tick 3?
		- given at tick 4?
		
	- test all instructions together
		- like test 4 instructions in some way or another 
	
	- what to do with overflow -> just truncate it like normal
	
	
	
	
	//mix of hardware anbd simulation results? -> run each instruciton one at a time simulation, 
	//spaced out by like 100ns so see clear distinction of each instruciton
	
	*/
	// make sure variables are fresh each time, and if we run task twice vairables aren't saved from last tim e
	
	
	// in/out
	
	// SINGLE COMMAND (ARRAYS)
	// reg and all values at tick 1
	// reg and all values at tick 2
	// reg and all values at tick 3
	// reg and all values at tick 4
	
	// next command all reg and all values at all ticks 
	
	// rst, bus, R0, R1, R2, R3, R4, R5, R6, R7, FSM_tick
	// 
	
	// have one task that checks all of the contents of the registers and compare it to the prewritten list
	// task -> instruction actually doing -> check that everything is ok 
	// task -> test edge case conditions
	// task -> check initial state
	// task -> check reset is working properly
	
	
	integer i;
	// define io to be tested
	
	reg [0:0] clk_proc = 1'd0;
	reg [0:0] rst_proc = 1'd0;
	reg [8:0] currentDin;
	// define 1D array for the register values in the processor
	wire [15:0] currentRegVal [0:7];
	
	wire [15:0] bus_proc;
	wire [3:0] current_tick;
	
	reg [15:0] expRegVal [0:7]; 
	reg [3:0] expCurTick;
	
	
	// instantiate module to be tested
	simple_proc DUT_proc (
		.clk(clk_proc),
		.rst(rst_proc),
		.din(currentDin),
		.bus(bus_proc),
		.R0(currentRegVal[0]),
		.R1(currentRegVal[1]),
		.R2(currentRegVal[2]),
		.R3(currentRegVal[3]),
		.R4(currentRegVal[4]),
		.R5(currentRegVal[5]),
		.R6(currentRegVal[6]),
		.R7(currentRegVal[7]),
		.FSM_tick(current_tick)
	);
	
	// set up clock for testing processor
	initial begin
		#12;
		
		// first clk posedge happens at #17-> 22, #27-> 32-> #37
		forever begin
			#5;
			clk_proc = ~clk_proc;
			// might be aftr check latr
		end
	
	end
	
	
	// set up test bench statistics
	integer test_count, errors;
	
	initial begin
		test_count = 0;
		errors = 0;
	end
	
	
	// testing tasks here
	initial begin
		#2;
		
		// TEST 1 -> Check initial state of processor
		
		// modify expected register values to be all 16'd0;
		exp_initial_state;
		
		#2;
		
		// test initial processor state and values
		check_states;
		test_count = test_count + 1;
		
		#2;
		
		
		
		// TEST 2-> Check reset works
		
		// force value
		rst_force_logic;
		@(posedge clk_proc);
		
		@(negedge clk_proc) rst_proc = 1'd1;
		
		@(posedge clk_proc) begin
			// wait for values to settle
			#2;
			
			// reset should set everythign back to initial states
			check_states;
			test_count = test_count + 1;
		
		end
		
		
		/*
			movi
			add
			addi
			sub
			
			immediate type instructions first then reg to reg
		*/
		
		
		// TEST 3 -> MOVI
		
		@(negedge clk_proc) begin
			rst_proc = 1'd0;
			currentDin = 9'b111001000; // 111 001 000 -> Select reg 1 to move an immediate value into
			expCurTick = 4'b0010; // modify exp tick for next pos edge
		end
	
		@(posedge clk_proc) tick_advance; // current tick should be 0010, awaiting an immediate value
		
		@(negedge clk_proc) begin
			currentDin = 9'b000000111; // load in the value 16'd7 into register 1
			expRegVal[1] = 16'd7; // modify reg value for reg 1 so it matches test case
			expCurTick = 4'b0100;
		end
		
		// check that tick 0010 has completed successfully
		@(posedge clk_proc) tick_advance;
		
		@(negedge clk_proc) expCurTick = 4'b1000; // modify exp current tick for tick 4
		
		// check tick 0100 has completely successfully
		@(posedge clk_proc) tick_advance;
		
		@(negedge clk_proc) expCurTick = 4'b0001; // modify expected to go back to tick 1
		
		// check tick 1000 has completely successfully
		@(posedge clk_proc) tick_advance;
		
		
		
		// TEST 4 -> ADDI
		@(negedge clk_proc) begin
			currentDin = 9'b010001000; // 010 001 000 -> add an immediate value into reg 1
			expCurTick = 4'b0010;
		end
		
		@(posedge clk_proc) tick_advance; // current tick should be 0010, awaiting an immediate value
		
		@(negedge clk_proc) begin
			currentDin = 9'b000000100; // 000 000 100 -> 16'd4
			expCurTick = 4'b0100;
		end
		
		// check that tick 2 has completed successfully tick goes onto 0100
		@(posedge clk_proc) tick_advance;
		
		@(negedge clk_proc) begin
			expCurTick = 4'b1000;
		end
		
		// check that tick 3 has completed successfully tick goes onto 1000
		@(posedge clk_proc) tick_advance;
		
		@(negedge clk_proc) begin
			expCurTick = 4'b0001;
			expRegVal[1] = 16'd11; // since reg 1 had value of 7, now added 4 = 11
		end
		
		// Check tick 4 success, and that tick goes to 4'b0001
		@(posedge clk_proc) tick_advance;
		
		
		
		
		
		// TEST 5 -> ADD
		
		@(negedge clk_proc) begin
			currentDin = 9'b001000001; // 001 000 001 -> Add the value of R1 into R0 
			expCurTick = 4'b0010;
		end
		
		// Check tick 1 complete, also advances
		@(posedge clk_proc) tick_advance;
		
		
		// Modify next tick's next state to be 0100
		@(negedge clk_proc) expCurTick = 4'b0100;
		
		// Do tick 2, advance to tick 4'b0100;
		@(posedge clk_proc) tick_advance;
			
		@(negedge clk_proc) expCurTick = 4'b1000;
		
		// Do tick 3, advance to tick 4'b1000;
		@(posedge clk_proc) tick_advance;
		
		@(negedge clk_proc) begin
			expCurTick = 4'b0001;
			expRegVal[0] = 16'd11; // should match the same as reg 1
		end
		
		// do final tick and tick processor returns back to tick 4'b0001;
		@(posedge clk_proc) tick_advance;
		
		
		
		
		
		// TEST 6 -> SUB
		
		@(negedge clk_proc) begin
			expCurTick = 4'b0010;
			currentDin = 9'b011010001; // 011 010 001: R2 = R2 - R1
		end
		
		// Check tick 1 complete, also advances
		@(posedge clk_proc) tick_advance;
		
		// Modify next tick's next state to be 0100
		@(negedge clk_proc) expCurTick = 4'b0100;
		
		// Do tick 2, advance to tick 4'b0100;
		@(posedge clk_proc) tick_advance;
			
		@(negedge clk_proc) expCurTick = 4'b1000;
		
		// Do tick 3, advance to tick 4'b1000;
		@(posedge clk_proc) tick_advance;
		
		@(negedge clk_proc) begin
			expCurTick = 4'b0001;
			expRegVal[2] = 16'b1111111111110101; // should be -16'd11 -> a two's complement negative number
		end
		
		// do final tick and tick processor returns back to tick 4'b0001;
		@(posedge clk_proc) tick_advance;
		
		$display("SUMMARY OF SIMPLE PROCESSOR TEST BENCH");
		
		$display("Errors: %d",
			errors
			);
			
		$display("Tests conducted: %d",
			test_count
			);
		
		$display("TESTS CONDUCTED:");
		$display("Intial state check, reset, add, sub, movi, addi");
		
		$stop;
		
	end
	
	
	
	
	
	
	
	
	
	
	task check_states;
		reg error_found;
	
		begin
			error_found = 1'b0;
			
			// test current reg values equal expected reg values
			for (i=0; i<8; i=i+1) begin
			
				if (currentRegVal[i] !== expRegVal[i]) begin
				
					$display(
					"Time: %0t Register value mismatch error! \n Register %d: Expected %b, got %b",
					$time,
					i,
					expRegVal[i],
					currentRegVal[i]
					);
					
					error_found = 1'b1;
					
				end
				
			end
			
			// test fsm state
			
				if (current_tick !== expCurTick) begin
				
					$display(
					"Time: %0t FSM state error! \n Expected state %b, got %b",
					$time,
					expCurTick,
					current_tick
					);
					
					error_found = 1'b1;
					
				end
				
				// add error if either error occurred
				if (error_found) errors = errors + 1;
				
		
		end
	
	endtask
	
	
	
	
	// how do we minimise the checking of the regs of the ones that shouldnt change? minimise it all into one task
	// loop task have input parameters as the output_Reg and also exp value for each reg (usually 0)
	
	// ok actual general workflow
	// task for checking instruciton/state
	// 1d array to check the reg values at that state 
	// use a function block to check that the values match, and then you can display error if or if not
	// task -> instruction/state executed -> function to check correct values -> error message, yes or no
	
	
	
	task exp_initial_state;
	
	// use a for loop to assign expected values for reg to be 0
		begin
		
			expCurTick = 4'b0001;
			
			for (i=0; i<8; i=i+1) begin
				expRegVal[i] = 16'b0;
			end
		
		end
	
	endtask
	
	
	
	task rst_force_logic;
	
		begin
		
			// force Registers to be a certain value, and then release so processor can utilise reset
			
			force DUT_proc.output_R0 = 16'd1;
			force DUT_proc.output_R1 = 16'd1;
			force DUT_proc.output_R2 = 16'd1;
			force DUT_proc.output_R3 = 16'd1;
			force DUT_proc.output_R4 = 16'd1;
			force DUT_proc.output_R5 = 16'd1;
			force DUT_proc.output_R6 = 16'd1;
			force DUT_proc.output_R7 = 16'd1;
			#2;
			release DUT_proc.output_R0;
			release DUT_proc.output_R1;
			release DUT_proc.output_R2;
			release DUT_proc.output_R3;
			release DUT_proc.output_R4;
			release DUT_proc.output_R5;
			release DUT_proc.output_R6;
			release DUT_proc.output_R7;
		
		end
	
	endtask
	
	task tick_advance;
		begin
			#2;
			check_states;
			test_count = test_count + 1;
		end
	
	endtask
	
	task reset_proc;
	
		begin
			@(negedge clk_proc) rst_proc = 1'd1;
			@(posedge clk_proc);
			@(negedge clk_proc) rst_proc = 1'd0;
			
			// reset all exp values of state of proc
			exp_initial_state;
		end
	
	
	endtask
	
endmodule