module clock_div_10hz (
	input clk,
	output reg [0:0] tick
);

	reg [24:0] counter;
	
	always @(posedge clk) begin
	
		if (counter == 25'd5000000) begin
			counter <= 25'd0;
			tick <= 1'd1;
			
		end else begin
			counter <= counter + 25'd1;
			tick <= 1'd0;
		end

	end

endmodule