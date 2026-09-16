// use the double dabble algorithm
// AI -> help get idea


module binary_to_bcd (
	input [15:0] binary,
	output [19:0] bcd

);
	
	/* n + 4*ceil(n/3)
		where n = bit length of binary input
		16 + 4*ceil(16/3)
		16 + 4 * 6 = 40
		
		no its actually 5hex * 4bits + 16bit original = 36 bits wide scratch space
	
	*/
	reg [35:0] scratch_space;
	
	assign bcd = scratch_space[35:16];
	

	integer i;
	
	always @(*) begin
		// iterate n times (16)
		scratch_space = 36'b0;
		scratch_space[15:0] = binary;
		
		for (i=0; i<16; i=i+1) begin
			// check top four bits [39:36]
			if (scratch_space[35:32] >= 4'd5) begin
				scratch_space[35:32] = scratch_space[35:32] + 4'd3;
			end
			
			// [35:32]
			if (scratch_space[31:28] >= 4'd5) begin
				scratch_space[31:28] = scratch_space[31:28] + 4'd3;
			end
			
			// [31:28]
			if (scratch_space[27:24] >= 4'd5) begin
				scratch_space[27:24] = scratch_space[27:24] + 4'd3;
			end
			
			// [27:24]
			if (scratch_space[23:20] >= 4'd5) begin
				scratch_space[23:20] = scratch_space[23:20] + 4'd3;
			end
			
			// [23:20]
			if (scratch_space[19:16] >= 4'd5) begin
				scratch_space[19:16] = scratch_space[19:16] + 4'd3;
			end
			
			// shift by 1
			scratch_space = scratch_space << 1;
			
		end
	
	end

endmodule

module seven_seg_display (
	input [3:0] display,
	output reg [6:0] segment
);

	always @(*) begin
		case (display)
			default: segment = 7'b0;
			4'd0: segment = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}; // 6 5 4 3 2 1 0
			4'd1: segment = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1};
			4'd2: segment = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
			4'd3: segment = {1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
			4'd4: segment = {1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1};
			4'd5: segment = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0};
			4'd6: segment = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
			4'd7: segment = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0};
			4'd8: segment = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
			4'd9: segment = {1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0};
		endcase
	end
endmodule
