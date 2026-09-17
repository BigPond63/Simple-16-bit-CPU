module clock_div_4hz (
	input clk,
	output reg [0:0] tick
);

	reg [26:0] counter;
	
	always @(posedge clk) begin
	
		if (counter == 27'd12500000) begin
			counter <= 27'b0;
			tick <= 1'b1;
			
		end else begin
			counter <= counter + 1;
			tick <= 1'b0;
		end

	end

endmodule