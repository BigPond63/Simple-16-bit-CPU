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
	 input [8:0] din;
	 input [15:0] R0;
	 input [15:0] R1;
	 input [15:0] R2;
	 input [15:0] R3;
	 input [15:0] R4;
	 input [15:0] R5;
	 input [15:0] R6;
	 input [15:0] R7;
	 
	 output [15:0] bus; // check


    // TODO: declare wires:
	 wire [15:0] sign_ext_output;
	 wire [15:0] output_R0;
	 wire [15:0] output_R1;
	 wire [15:0] output_R2;
	 wire [15:0] output_R3;
	 wire [15:0] output_R4;
	 wire [15:0] output_R5;
	 wire [15:0] output_R6;
	 wire [15:0] output_R7;
	 wire [15:0] output_R8;
	 wire [15:0] output_G;
	 wire [15:0] output_A;
	 wire [8:0] output_IR;
	 
	 wire [15:0] alu_in_A;
	 wire [15:0] alu_in_B;
	 wire [15:0] alu_op_wire;
	 wire [15:0] alu_out;
	 wire [3:0] tick_fsm_out;
    

    // TODO: instantiate registers:
	 register_n #(.N(9)) reg_IR(
		.data_in(din),
		.r_in(1), 
		.clk(clk), 
		.Q(output_IR), 
		.rst(rst)
		);
		
	register_n #(.N(16)) reg_R0(
		data_in,
		.r_in(1), 
		.clk(clk), 
		.Q(output_R0), 
		.rst(rst)
		);
		
	register_n #(.N(16)) reg_R1(
		data_in,
		.r_in(1), 
		.clk(clk), 
		.Q(output_R1), 
		.rst(rst)
		); 
		
	register_n #(.N(16)) reg_R2(
		data_in,
		r_in, 
		.clk(clk), 
		.Q(output_R2), 
		.rst(rst)
		); 

	register_n #(.N(16)) reg_R3(
		data_in,
		r_in, 
		.clk(clk), 
		.Q(output_R3), 
		.rst(rst)
		); 

	register_n #(.N(16)) reg_R4(
		data_in,
		r_in, 
		.clk(clk), 
		.Q(output_R4), 
		.rst(rst)
		); 

	register_n #(.N(16)) reg_R5(
		data_in,
		r_in, 
		.clk(clk), 
		.Q(output_R5), 
		.rst(rst)
		); 

	register_n #(.N(16)) reg_R6(
		data_in,
		r_in, 
		.clk(clk), 
		.Q(output_R6), 
		.rst(rst)
		); 

	register_n #(.N(16)) reg_R7(
		data_in,
		r_in, 
		.clk(clk), 
		.Q(output_R7), 
		.rst(rst)
		); 
		
	register_n #(.N(16)) reg_G(
		.data_in(alu_out_wire)
		r_in, 
		.clk(clk), 
		.Q(output_G),
		.rst(rst)
		);
	
	// intermediate calculation here?
	register_n #(.N(16)) reg_A(
		.data_in,
		r_in, 
		.clk(clk), 
		.Q(output_A), 
		.rst(rst)
		); 
    
    
    // TODO: instantiate Multiplexer:
	 multiplexer ins0 (
		.SignExtDin(sign_ext_output),
		.R0(output_R0),
		.R1(output_R1),
		.R2(output_R2),
		.R3(output_R3),
		.R4(output_R4),
		.R5(output_R5),
		.R6(output_R6),
		.R7(output_R7),
		.G(output_G),
		.sel(),
		.Bus(bus)
	);
    
    
    // TODO: instantiate ALU:
	 ALU ins0 (
		.input_a(alu_in_A),
		.input_b(alu_in_B),
		.alu_op(alu_op_wire),
		.result(alu_out)
	);
    
    

    // TODO: instantiate tick counter:
	 tick_FSM ins0 (
		.rst(rst),
		.clk(clk),
		.enable,
		.tick(tick_fsm_out)
	);
	
	// instantiate sign extender for data input:
	sign_extend ins0 (
		.in(din),
		.ext(sign_ext_output)
	);
    
    // input to control unit -> current instruction and tick FSM output
    // TODO: define control unit:
    always @(tick_fsm_out || output_IR) begin
        // TODO: Turn off all control signals:


        // TODO: Turn on specific control signals based on current tick:
        case (tick_fsm_out)
            /* Tick 1 */
				4'b0001:
                begin
                    // TODO
                end
            
            /* Tick 2 */
				4'b0010:
                begin
                    // TODO
                end
            
            /* Tick 3 */
				4'b0100:
                begin
                    // TODO
                end
            
            /* Tick 4 */
				4'b1000:
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