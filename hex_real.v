// THIS IS ONLY TO TEST FSM

module hex_real (
    input  [3:0] one_hot_state,       
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3
);

	wire A, B, C, D;
	
	assign A = fsm[3];
	assign B = fsm[2];
	assign C = fsm[1];
	assign D = fsm[0];
	
    // seg[6:0] = {g,f,e,d,c,b,a}, active-low
    assign HEX0 = {1'b1, D, D, D, 1'b0, 1'b0, D};
    assign HEX1 = {1'b1, C, C, C, 1'b0, 1'b0, C};
    assign HEX2 = {1'b1, B, B, B, 1'b0, 1'b0, B};
    assign HEX3 = {1'b1, A, A, A, 1'b0, 1'b0, A};
endmodule