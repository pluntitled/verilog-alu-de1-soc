module top
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

lab2 #(.DATA_WIDTH(DATA_WIDTH), .RESULT_WIDTH(DATA_WIDTH), .ALT_WIDTH(ALT_WIDTH), .ALT_EN(ALT_EN), .OVERFLOW_EN(OVERFLOW_EN)) lab2 (.x1(a), .x2(b), .c1(op), .c2(alt), .y(s), .z(overflow));

endmodule 