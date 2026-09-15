module proc_top_level (
	input [8:0] SW,
	input [1:0] KEY,
	output [9:0] LEDR
	
);

wire [15:0] bus_wire;
simple_proc ins0 (
	.clk(~KEY[1]),
	.rst(~KEY[0]),
	.din(SW[8:0]),
	.bus(bus_wire)
);

assign LEDR = bus_wire[9:0];

endmodule