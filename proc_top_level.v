module proc_top_level (
	input [9:0] SW,
	input [1:0] KEY,
	output [9:0] LEDR,
	
	output [7:0] HEX0,
	output [7:0] HEX1,
	output [7:0] HEX2,
	output [7:0] HEX3,
	output [7:0] HEX4,
	output [7:0] HEX5
);


wire [15:0] bus_wire;
wire [3:0] fsm_state;
wire [15:0] display_wire;
wire [19:0] bcd_wire;

wire [3:0] HEX0_wire;
wire [3:0] HEX1_wire;
wire [3:0] HEX2_wire;
wire [3:0] HEX3_wire;
wire [3:0] HEX4_wire;


assign LEDR = bus_wire[9:0];

assign HEX4_wire = bcd_wire[19:16];
assign HEX3_wire = bcd_wire[15:12];
assign HEX2_wire = bcd_wire[11:8];
assign HEX1_wire = bcd_wire[7:4];
assign HEX0_wire = bcd_wire[3:0];


proc_extension proc_ext_ins0 (
	.clk(~KEY[1]),
	.rst(~KEY[0]),
	.enable(SW[9]),
	.din(SW[8:0]),
	.bus(bus_wire),
	.R0(fsm_state),
	.display(display_wire)
);



/*
hex_real hex_ins0 (
	.one_hot_state(hex_wire),
	.HEX0(HEX0),
	.HEX1(HEX1),
	.HEX2(HEX2),
	.HEX3(HEX3)
	);
*/

binary_to_bcd bcd_ins0 (
	.binary(display_wire),
	.bcd(bcd_wire)
);

seven_seg_display HEX0_ins0 (
	.display(HEX0_wire),
	.sign(display_wire[15]),
	.segment(HEX0)
);

seven_seg_display HEX1_ins0 (
	.display(HEX1_wire),
	.sign(display_wire[15]),
	.segment(HEX1)
);

seven_seg_display HEX2_ins0 (
	.display(HEX2_wire),
	.sign(display_wire[15]),
	.segment(HEX2)
);

seven_seg_display HEX3_ins0 (
	.display(HEX3_wire),
	.sign(display_wire[15]),
	.segment(HEX3)
);

seven_seg_display HEX4_ins0 (
	.display(HEX4_wire),
	.sign(display_wire[15]),
	.segment(HEX4)
);

fsm_state_hex_decoder fsm_hex_ins0 (
	.state(fsm_state),
	.sign(display_wire[15]),
	.segment(HEX5)
);


endmodule