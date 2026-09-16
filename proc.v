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
	 output [3:0] R0;
	 output [15:0] R1;
	 output [15:0] R2;
	 output [15:0] R3;
	 output [15:0] R4;
	 output [15:0] R5;
	 output [15:0] R6;
	 output [15:0] R7;
	 
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
	 wire [15:0] alu_out_wire;
	 wire [3:0] tick_fsm_out;
	 wire [15:0] bus_wire;
	 
	 
	 
	 reg [3:0] sel_reg;
	 reg [2:0] alu_op_reg;
	 reg G_in;
	 reg A_in;
	 reg [7:0] R_in;
	 reg IR_in;

	 
    
	 assign bus = bus_wire;

    // TODO: instantiate registers:
	 register_n #(.N(9)) reg_IR(
		.data_in(din),
		.r_in(IR_in), 
		.clk(clk), 
		.Q(output_IR), 
		.rst(rst)
		);
		
	register_n #(.N(16)) reg_R0(
		.data_in(bus_wire),
		.r_in(R_in[0]), 
		.clk(clk), 
		.Q(output_R0), 
		.rst(rst)
		);
		
	register_n #(.N(16)) reg_R1(
		.data_in(bus_wire),
		.r_in(R_in[1]), 
		.clk(clk), 
		.Q(output_R1), 
		.rst(rst)
		); 
		
	register_n #(.N(16)) reg_R2(
		.data_in(bus_wire),
		.r_in(R_in[2]), 
		.clk(clk), 
		.Q(output_R2), 
		.rst(rst)
		); 

	register_n #(.N(16)) reg_R3(
		.data_in(bus_wire),
		.r_in(R_in[3]), 
		.clk(clk), 
		.Q(output_R3), 
		.rst(rst)
		); 

	register_n #(.N(16)) reg_R4(
		.data_in(bus_wire),
		.r_in(R_in[4]), 
		.clk(clk), 
		.Q(output_R4), 
		.rst(rst)
		); 

	register_n #(.N(16)) reg_R5(
		.data_in(bus_wire),
		.r_in(R_in[5]), 
		.clk(clk), 
		.Q(output_R5), 
		.rst(rst)
		); 

	register_n #(.N(16)) reg_R6(
		.data_in(bus_wire),
		.r_in(R_in[6]), 
		.clk(clk), 
		.Q(output_R6), 
		.rst(rst)
		); 

	register_n #(.N(16)) reg_R7(
		.data_in(bus_wire),
		.r_in(R_in[7]), 
		.clk(clk), 
		.Q(output_R7), 
		.rst(rst)
		); 
		
	register_n #(.N(16)) reg_G(
		.data_in(alu_out_wire),
		.r_in(G_in), 
		.clk(clk), 
		.Q(output_G),
		.rst(rst)
		);
	
	// intermediate calculation here?
	register_n #(.N(16)) reg_A(
		.data_in(bus_wire),
		.r_in(A_in), 
		.clk(clk), 
		.Q(output_A), 
		.rst(rst)
		);
    
    
    // TODO: instantiate Multiplexer:
	 multiplexer mux_ins0 (
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
		.sel(sel_reg),
		.Bus(bus_wire)
	);
    
    
    // TODO: instantiate ALU:
	 ALU alu_ins0 (
		.input_a(output_A),
		.input_b(bus_wire),
		.alu_op(alu_op_reg),
		.result(alu_out_wire)
	);
    
    

    // TODO: instantiate tick counter:
	 tick_FSM fsm_ins0 (
		.rst(rst),
		.clk(clk),
		.enable(1),
		.tick(tick_fsm_out)
	);
	
	// instantiate sign extender for data input:
	sign_extend ext_ins0 (
		.in(din),
		.ext(sign_ext_output)
	);
    
    // input to control unit -> current instruction and tick FSM output
    // TODO: define control unit:
    always @(tick_fsm_out, output_IR) begin
        // TODO: Turn off all control signals:
		  R_in = 8'b0;
		  A_in = 1'b0;
		  G_in = 1'b0;
		  alu_op_reg = 3'd7; // 3'b111 is default 0's as alu output
		  IR_in = 1'b0;
		  sel_reg = 4'b1111;


        // TODO: Turn on specific control signals based on current tick:
        case (tick_fsm_out)
            /* Tick 1 */
				4'b0001:
                begin
                   /* TODO
						 addition of two registers
						 Rx = Rx + Ry
						 eg. 23 + 11 -> lets say Rx = R0 and Ry = R1
						 instruction is 001 000 001 from IR
						 */
						 IR_in = 1'b1;
                end
            
            /* Tick 2 */
				4'b0010:
					begin
                    // TODO
						  /*
						  value of Rx (23) placed onto bus
						  store bus value into reg A
						  assume rx = r0, ry = r1
						  */
						case (output_IR[8:6]) 
							// addition store into A
							3'd1: begin
								A_in = 1'b1;
								sel_reg = {1'b0, output_IR[5:3]};
							end
							
							3'd2: begin
								A_in = 1'b1;
								sel_reg = 4'd9; // selection for the sign ext din
							end
							
							3'd3: begin
								A_in = 1'b1;
								sel_reg = {1'b0, output_IR[5:3]};
							end
							
							3'd7: begin
								sel_reg = 4'd9;
								R_in[output_IR[5:3]] = 1'b1; // activate Rx
							end
							
							default: ;
						  
						endcase
						  
                end
            
            /* Tick 3 */
				4'b0100:
                begin
                    // TODO
						  /*
						  value in ry is placed onto bus
						  alu calculates value in reg A and bus wire
						  addition
						  reg G stores result
						  */
						  
						  case (output_IR[8:6]) 
								default: ;
								
							  3'd1: begin
									sel_reg = {1'd0, output_IR[2:0]};
									alu_op_reg = 3'd1;
							  
									G_in = 1'd1; // store result in reg G
								end
								
								3'd2: begin
									sel_reg = {1'd0, output_IR[5:3]};
									alu_op_reg = 3'd1;
									
									G_in = 1'd1;
								end
								
								3'd3: begin
									sel_reg = {1'd0, output_IR[2:0]};
									alu_op_reg = 3'd2;
									
									G_in = 1'd1;
								end
								
								3'd7: ; // idle
								
							  endcase
						  
                end
            
            /* Tick 4 */
				4'b1000:
                begin
                    // TODO
						  /*
						  value in reg G is placed onto the bus
						  */
						  
						  case (output_IR[8:6])
								default: ;
						  
								3'd1: begin
						  
								  // G placed onto bus
								  sel_reg = 4'd8; // kinda hard coded here
								  // value enters Rx as it is enabled
								  R_in[output_IR[5:3]] = 1'b1; 
								  end
								  
								3'd2: begin
									sel_reg = 4'd8;
									R_in[output_IR[5:3]] = 1'b1; 
								end
								
								3'd3: begin
									sel_reg = 4'd8; // g
									R_in[output_IR[5:3]] = 1'b1; // rx
								end
								
								3'd7: ; // idle
								
							endcase
						  
                end
            
            default:
                begin
                    // TODO
                end

        endcase

    end

endmodule