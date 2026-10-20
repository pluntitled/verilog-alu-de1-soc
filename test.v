`timescale 1ns/1ps
module test;

reg [7:0] a, b, alt;
reg [1:0] op;
wire [7:0] s; 
reg overflow;

lab2 dut(
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
		alt = 1'b0;
		op = 2'b00;
		#2;
		op = 2'b01;
		#2;
		op = 2'b10;
		#2;
		op = 2'b11;
		#2;
		
		alt = 1'b1;
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