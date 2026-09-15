module proc_top_level (
	input [8:0] SW,
	input [1:0] KEY,
	output [9:0] LEDR,
	
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3
);


wire [15:0] bus_wire;
assign LEDR = bus_wire[9:0];
assign LEDR[9] = 1'b0;
wire [3:0] hex_wire;

simple_proc ins0 (
	.clk(~KEY[1]),
	.rst(~KEY[0]),
	.din(SW[8:0]),
	.bus(bus_wire),
	.R0(hex_wire)
);

hex_real hex_ins0 (
	.one_hot_state(hex_wire),
	.HEX0(HEX0),
	.HEX1(HEX1),
	.HEX2(HEX2),
	.HEX3(HEX3)
	);

endmodule