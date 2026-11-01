`timescale 1ns/1ps
module test;

reg [7:0] a, b;
reg [3:0] alt;
reg [1:0] op;
wire [7:0] s; 
wire overflow;

lab2 #(
	.ALT_EN(1),
	.OVERFLOW_EN(1)
) dut (
	.a(a),
	.b(b),
	.alt(alt),
	.op(op),
	.s(s),
	.overflow(overflow)
	
);


initial begin
	repeat(5) begin
		a = $random;
		b = $random;
		alt = 4'b0000;
		op = 2'b00;
		#2;
		op = 2'b01;
		#2;
		op = 2'b10;
		#2;
		op = 2'b11;
		#2;
		
		alt = 4'b1111;
		op = 2'b00;
		#2;
		op = 2'b01;
		#2;
		op = 2'b10;
		#2;
		op = 2'b11;
		#2;
	end
end
endmodule 