module test_IP (
	input CLOCK_50,
	input [1:0] KEY,
	input [9:9] SW,
	
	output [9:0] LEDR,
	output [7:0] HEX0,
	output [7:0] HEX1,
	output [7:0] HEX2,
	output [7:0] HEX3,
	output [7:0] HEX4,
	output [7:0] HEX5
);
// this clock is 50,000,000 ticks per second -> want 10 ticks (10hz)
// do a counter up to 5,000,000, every tick up to this number is a clock pulse

wire tick;
wire [15:0] pc_address;
wire [8:0] din;

wire [15:0] bus_wire;
wire [3:0] fsm_state;
wire [15:0] display_wire;
wire [19:0] bcd_wire;

wire [3:0] HEX0_wire;
wire [3:0] HEX1_wire;
wire [3:0] HEX2_wire;
wire [3:0] HEX3_wire;
wire [3:0] HEX4_wire;


assign LEDR[9:0] = bus_wire[9:0];

assign HEX4_wire = bcd_wire[19:16];
assign HEX3_wire = bcd_wire[15:12];
assign HEX2_wire = bcd_wire[11:8];
assign HEX1_wire = bcd_wire[7:4];
assign HEX0_wire = bcd_wire[3:0];

/*
module ROM1P_Q9_65536 (
	address,
	clock,
	q);

	input	[15:0]  address;
	input	  clock;
	output	[8:0]  q;

*/


proc_memory memory_ins0(
	.clk(tick),
	.rst(~KEY[0]&&SW[9]),
	.din(din),
	.bus(bus_wire),
	.display(display_wire),
	.enable(SW[9]),
	.pc_addr(pc_address),
	.fsm_tick(fsm_state)
	
);

clock_div_10hz clock10hz (
	.clk(CLOCK_50),
	.tick(tick)
);

/*
clock_div_4hz clock4hz (
	.clk(CLOCK_50),
	.tick(tick)
);
*/


ROM1P_Q9_65536 ROM1P_ins0 (
	.address(pc_address),
	.clock(CLOCK_50),
	.q(din)
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