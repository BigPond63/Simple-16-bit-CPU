module simp_proc_top_level (
	input [8:0] SW,
	input [1:0] KEY,
	
	output [9:0] LEDR,
	output [7:0] HEX5
	
	);
	
	wire [15:0] bus_wire;
	wire [3:0] fsm_state;
	
	assign LEDR = bus_wire[9:0];

simple_proc proc_ins0 (
	.clk(~KEY[1]),
	.rst(~KEY[0]),
	.din(SW[8:0]),
	.bus(bus_wire),
	.FSM_tick(fsm_state)
);

fsm_state_hex_decoder fsm_hex_ins0 (
	.state(fsm_state),
	.sign(1'b0),
	.segment(HEX5)
);
	
	

	
	
endmodule
	