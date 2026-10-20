module bin2bcd #(
	parameter WIDTH = 6
)

(
	input wire [WIDTH-1:0]bin,
	output reg [7:0]bcd
);

	 integer i;
	 
	 always @(*) begin
		bcd = 8'b0;
		
		for (i = WIDTH-1; i >= 0; i = i-1) begin
			if (bcd[7:4] >= 5)
				bcd[7:4] = bcd[7:4] + 4'd3;
			else
				bcd[7:4] = bcd[7:4];
			
			if (bcd[3:0] >= 4'd5)
				bcd[3:0] = bcd[3:0] + 4'd3;
			else
				bcd[3:0] = bcd[3:0];
			
			bcd = {bcd[6:0], bin[i]};
		end
	end
endmodule	