/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual the CPU.

Please enter your student ID:

*/
module simple_proc(clk, rst, din, bus, R0, R1, R2, R3, R4, R5, R6, R7);

    // Note: The skeleton you are provided with includes output ports to output the values of the internal registers R0 - R7, for the purpose of test benching. When instantiating the processor to program your DE10-lite, you can leave these ports unused.

    // TODO: Declare inputs and outputs:
	 input [0:0] clk;
	 input [0:0] rst;
	 input [15:0] bus;
	 input [15:0] din;
	 input [15:0] R0;
	 input [15:0] R1;
	 input [15:0] R2;
	 input [15:0] R3;
	 input [15:0] R4;
	 input [15:0] R5;
	 input [15:0] R6;
	 input [15:0] R7;


    // TODO: declare wires:
    

    // TODO: instantiate registers:
	 register_n #(.N(9)) reg_IR(
		data_in,
		r_in, 
		clk, 
		Q, 
		rst
		);
		
	register_n #(.N(16)) reg_R0(
		data_in,
		r_in, 
		clk, 
		Q, 
		rst
		);
		
	register_n #(.N(16)) reg_R1(
		data_in,
		r_in, 
		clk, 
		Q, 
		rst
		); 
		
	register_n #(.N(16)) reg_R2(
		data_in,
		r_in, 
		clk, 
		Q, 
		rst
		); 

	register_n #(.N(16)) reg_R3(
		data_in,
		r_in, 
		clk, 
		Q, 
		rst
		); 

	register_n #(.N(16)) reg_R4(
		data_in,
		r_in, 
		clk, 
		Q, 
		rst
		); 

	register_n #(.N(16)) reg_R5(
		data_in,
		r_in, 
		clk, 
		Q, 
		rst
		); 

	register_n #(.N(16)) reg_R6(
		data_in,
		r_in, 
		clk, 
		Q, 
		rst
		); 

	register_n #(.N(16)) reg_R7(
		data_in,
		r_in, 
		clk, 
		Q, 
		rst
		); 
    
    
    // TODO: instantiate Multiplexer:
    
    
    // TODO: instantiate ALU:
    
    
    // TODO: instantiate tick counter:
    
    
    // TODO: define control unit:
    always @(/* List signals that can change the control unit's output */) begin
        // TODO: Turn off all control signals:


        // TODO: Turn on specific control signals based on current tick:
        case (/* your counter value goes here */)
            /* Tick 1 */:
                begin
                    // TODO
                end
            
            /* Tick 2 */:
                begin
                    // TODO
                end
            
            /* Tick 3 */:
                begin
                    // TODO
                end
            
            /* Tick 4 */:
                begin
                    // TODO
                end
            
            default:
                begin
                    // TODO
                end

        endcase

    end

endmodule