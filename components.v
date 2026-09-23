/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual components to be used in 
    the CPU.

Please enter your name and student ID:

*/


module sign_extend(in, ext);
	/* 
	 * This module sign extends the 9-bit Din to a 16-bit output.
	 */
	 
	// TODO: Declare inputs and outputs
	input [8:0] in;
	output [15:0] ext;
	
	// TODO: implement logic
	assign ext = {{7{in[8]}}, in}; // extend MSB -> 1 = neg, 0 = pos
	
endmodule


// ok
module tick_FSM(rst, clk, enable, tick);	
	/* 
	 * This module implements a tick FSM that will be used to
	 * control the actions of the control unit
	 */
	 
	 // TODO: Declare inputs and outputs
	 input [0:0] clk;
	 input [0:0] rst;
	 input [0:0] enable; // en = 1 -> cycle state
	 output [3:0] tick; // one-hot state 0001 0010 0100 1000
	
	reg [3:0] tick_reg;
	reg [3:0] next_state;
	
	assign tick = tick_reg;
	
	// TODO: implement FSM
	always @(posedge clk) begin
	
		if (rst) begin
			tick_reg <= 4'b0001;
		end else begin
		
			case (enable)
				1'b0: tick_reg <= tick_reg;
				1'b1: tick_reg <= next_state;
			endcase
			
		end
	end
		
	always @(*) begin
	
		case (tick_reg)
			default: next_state = 4'b0001; 
			4'b0001: next_state = 4'b0010;
			4'b0010: next_state = 4'b0100;
			4'b0100: next_state = 4'b1000;
			4'b1000: next_state = 4'b0001;
		endcase
	end
	
    
endmodule



module multiplexer(SignExtDin, R0, R1, R2, R3, R4, R5, R6, R7, G, sel, Bus);
	/* 
	 * This module takes 10 inputs and places the correct input onto the bus.
	 */
	 
	 // TODO: Declare inputs and outputs
	 input [15:0] R0;
	 input [15:0] R1;
	 input [15:0] R2;
	 input [15:0] R3;
	 input [15:0] R4;
	 input [15:0] R5;
	 input [15:0] R6;
	 input [15:0] R7;
	 input [15:0] G;
	 input [15:0] SignExtDin;
	 input [3:0] sel;
	 output [15:0] Bus;
	 
	 reg [15:0] bus_reg;
	 assign Bus = bus_reg;
	 
	
	/*
		ONLY ASSERTED IF ENABLE SIGNAL ON REGISTER IS 1
		
	*/
	
	// TODO: implement logic
	always @(*) begin
		case (sel) // assumed logic here
			default: bus_reg = 16'b0;
			4'b0000: bus_reg = R0;
			4'b0001: bus_reg = R1;
			4'b0010: bus_reg = R2;
			4'b0011: bus_reg = R3;
			4'b0100: bus_reg = R4;
			4'b0101: bus_reg = R5;
			4'b0110: bus_reg = R6;
			4'b0111: bus_reg = R7;
			4'b1000: bus_reg = G;
			4'b1001: bus_reg = SignExtDin;
		endcase
	end

endmodule



module ALU (input_a, input_b, alu_op, result);
	/* 
	 * This module implements the arithmetic logic unit of the processor.
	 */
	 
	// TODO: declare inputs and outputs
	input [15:0] input_a;
	input [15:0] input_b;
	input [2:0] alu_op;
	output [15:0] result;
	
	reg [15:0] result_reg;
	reg [15:0] shift_amount;
	
	assign result = result_reg;
	
	
	/*
	CONTINUE
	*/
	// TODO: Implement ALU Logic:
	always @(*) begin
		shift_amount = 16'b0;
		case (alu_op)
			3'b000: result_reg = input_a * input_b; // doesn't account for overflow or maybe neg
			3'b001: result_reg = input_a + input_b;
			3'b010: result_reg = input_a - input_b;
			3'b011: begin // shift logic here
			
				
			// be careful of signed shift causing a wrap around
				if (input_a[15] == 1) begin
					// shift right (MSB neg)

					shift_amount = ~input_a + 16'd1; // Get 2's complement negation
					result_reg = $signed(input_b) >>> shift_amount; // use signed shift operator to preserve sign
					// all values must be signed for a signed shift to occur (verilog syntax)
					
					end else begin
						// shift left (MSB pos)
						result_reg = input_b << input_a;
					end
				end
			
			default: result_reg = 16'b0; // have to double check this
		
		endcase
	
	end


	
endmodule


// instance of register
module register_n(data_in, r_in, clk, Q, rst);


	// To set parameter N during instantiation, you can use:
	// register_n #(.N(num_bits)) reg_IR(.....), 
	// where num_bits is how many bits you want to set N to
	// and "..." is your usual input/output signals

	parameter N = 16;

	/* 
	 * This module implements registers that will be used in the processor.
	 */
	 
	 
	// TODO: Declare inputs, outputs, and parameter:
	input [N-1:0] data_in;
	input [0:0] r_in;
	input clk;
	input rst;
	output [N-1:0] Q;
	
	reg [N-1:0] Q_reg;
	
	// TODO: Implement register logic:
	
	assign Q = Q_reg;
	
	
	always @(posedge clk) begin
		if (rst) begin
			Q_reg <= {N{1'b0}};
		end else begin
			case (r_in)
				1'b0: Q_reg <= Q_reg;
				1'b1: Q_reg <= data_in;
			endcase
		end
		
	end
	
	
	
	
endmodule

