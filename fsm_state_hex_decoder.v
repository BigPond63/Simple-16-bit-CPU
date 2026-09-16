module fsm_state_hex_decoder (
	input [3:0] state,
	input [0:0] sign,
	output reg [7:0] segment

);

	always @(*) begin
		case (state)
			default: segment = 8'b1;
			4'b0001: segment = {~sign, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1};
			4'b0010: segment = {~sign, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
			4'b0100: segment = {~sign, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
			4'b1000: segment = {~sign, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1};
		endcase
	
	end
	
endmodule