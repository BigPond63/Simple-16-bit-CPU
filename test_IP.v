module test_IP (
	input CLOCK_50,
	
);
// this clock is 50,000,000 ticks per second -> want 10 ticks (10hz)
// do a counter up to 5,000,000, every tick up to this number is a clock pulse

wire tick;
/*
module ROM1P_Q9_65536 (
	address,
	clock,
	q);

	input	[15:0]  address;
	input	  clock;
	output	[8:0]  q;

*/

clock_div_10hz clock10hz (
	.clk(CLOCK_50),
	.tick(tick)
);


ROM1P_Q9_65536 ROM1P_ins0 (
	.address(/*program counter OUTPUT_PC*/),
	.clock(tick),
	.q(/*connect to data in for cpu*/)

);



endmodule