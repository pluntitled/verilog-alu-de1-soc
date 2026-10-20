module bcd2sev (

	input wire [3:0] bcd,
	output reg [6:0] sev
);

	always @(*) begin
		case (bcd)
			4'd0 : sev = 7'b1000000;
			4'd1 : sev = 7'b1111001;
			4'd2 : sev = 7'b0100100;
			4'd3 : sev = 7'b0110000;
			4'd4 : sev = 7'b0011001;
			4'd5 : sev = 7'b0010010;
			4'd6 : sev = 7'b0000010;
			4'd7 : sev = 7'b1111000;
			4'd8 : sev = 7'b0000000;
			4'd9 : sev = 7'b0010000;
			default : sev = 7'b1111111;
		endcase
	end
endmodule 