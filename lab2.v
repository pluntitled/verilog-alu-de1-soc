module lab2
#(
	parameter DATA_WIDTH = 8,
	parameter RESULT_WIDTH = DATA_WIDTH,
	parameter ALT_WIDTH = 4,
	parameter ALT_EN = 1,
	parameter OVERFLOW_EN = 0
)
(
	input [DATA_WIDTH-1:0] a,
	input [DATA_WIDTH-1:0] b,
	input [1:0] op,
	input [DATA_WIDTH-1:0]alt,
	output reg [RESULT_WIDTH-1:0] s,
	output reg [RESULT_WIDTH-1:0] overflow
);

always @(*) begin
	if (ALT_EN && &alt) begin
		case(op)
			2'b00 : s = 2*a % b;
			2'b01 : s = a * b - 3;
			2'b10 : s = a ^ ~b;
			2'b11 : s = ~(~a & b);
		endcase
	end
	else
		case(op)
			2'b00 : s = a % b;
			2'b01 : s = a * b;
			2'b10 : s = a ^ b;
			2'b11 : s = ~(a & b);
		endcase
	end
always @(*) begin
	if (OVERFLOW_EN) begin
		if (ALT_EN && &alt) begin
			case(op)
				2'b00 : overflow = (b == 0);
				2'b01 : overflow = (((a * b) > {RESULT_WIDTH{1'b1}}) || ((a * b) < 3));
				2'b10 : overflow = 0;
				2'b11 : overflow = 0;
			endcase
		end
		else
			case(op)
				2'b00 : overflow = (b == 0);
				2'b01 : overflow = ((a * b) > {RESULT_WIDTH{1'b1}});
				2'b10 : overflow = 0;
				2'b11 : overflow = 0;
			endcase
		end
	else begin
		overflow = 0;
	end
	end
endmodule
