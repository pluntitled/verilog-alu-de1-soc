module board_top
(
	input wire [9:0] sw,
	input wire [3:0] key,
	output wire [6:0] hex0, hex1, hex2, hex3, hex4, hex5,
	output wire [6:0] sev1, sev2, sev3, sev4, sev5, sev6,
	output wire ledr0
);

	wire [7:0] bcd1, bcd2, bcd3;
	wire [5:0] s;

	
	lab2 #(
		.DATA_WIDTH(4),
		.RESULT_WIDTH(6),
		.ALT_WIDTH(4),
		.ALT_EN(1),
		.OVERFLOW_EN(0)
)	
	alu_inst (
		.op(sw[9:8]),
		.b(sw[3:0]),
		.a(sw[7:4]),
		.alt(key[3:0]),
		.s(s[5:0]),
		.overflow(ledr0)
);

bin2bcd #(
	.WIDTH(4)
) bin2bcd_1 (
	.bin(sw[7:4]),
	.bcd(bcd1)
);

bin2bcd #(
	.WIDTH(4)
) bin2bcd_2 (
	.bin(sw[3:0]),
	.bcd(bcd2)
);

bin2bcd # (
	.WIDTH(6)
) bin2bcd_3 (
	.bin(s),
	.bcd(bcd3)
);

bcd2sev bin2sev_1 (
	.bcd(bcd1[7:4]),
	.sev(sev1)
);

bcd2sev bin2sev_2 (
	.bcd(bcd1[3:0]),
	.sev(sev2)
);

bcd2sev bin2sev_3 (
	.bcd(bcd2[7:4]),
	.sev(sev3)
);

bcd2sev bin2sev_4 (
	.bcd(bcd2[3:0]),
	.sev(sev4)
);

bcd2sev bin2sev_5 (
	.bcd(bcd3[7:4]),
	.sev(sev5)
);

bcd2sev bin2sev_6 (
	.bcd(bcd3[3:0]),
	.sev(sev6)
);

assign HEX5 = sev1;
assign HEX4 = sev2;
assign HEX3 = sev3;
assign HEX2 = sev4;
assign HEX1 = sev5;
assign HEX0 = sev6;

endmodule
