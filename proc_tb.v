`timescale 1ns/1ns
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
	task automatic initial_proc_state;
		
		begin
		
		end
	
	endtask

endmodule