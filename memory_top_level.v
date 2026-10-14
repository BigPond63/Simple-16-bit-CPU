module memory_top_level (
	input [9:0] SW,
	input [1:0] KEY,
	input CLOCK_50,
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
wire [0:0] ten_hz_tick;
wire [8:0] instruction;
wire [15:0] current_address;


assign LEDR = bus_wire[9:0];

assign HEX4_wire = bcd_wire[19:16];
assign HEX3_wire = bcd_wire[15:12];
assign HEX2_wire = bcd_wire[11:8];
assign HEX1_wire = bcd_wire[7:4];
assign HEX0_wire = bcd_wire[3:0];


proc_memory proc_memory_ins0 (
	.clk(ten_hz_tick),
	.rst(~KEY[0] && SW[9]),
	.enable(SW[9]),
	.din(instruction),
	.bus(bus_wire),
	.fsm_tick(fsm_state),
	.display(display_wire),
	.pc_addr(current_address)
);


clock_div_10hz ten_hz_ins0(
	.clk(CLOCK_50),
	.tick(ten_hz_tick)
);


ROM1P_65536_test memory_ins0(
	.address(current_address),
	.clock(CLOCK_50),
	.q(instruction)
);



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