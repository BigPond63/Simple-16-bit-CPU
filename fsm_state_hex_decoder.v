module fsm_state_hex_decoder (
	input [3:0] state,
	output reg [6:0] segment

);

	always @(*) begin
		case (state)
			default: segment = 7'b1;
			4'b0001: segment = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1};
			4'b0010: segment = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
			4'b0100: segment = {1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
			4'b1000: segment = {1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1};
		endcase
	
	end
	
endmodule