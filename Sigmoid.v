module Sigmoid(
	input	[15:0]	x,
	output	[15:0]	z
);

reg [15:0] slope [12:0];
reg [15:0] intercept [12:0];
initial begin
	$readmemh("slope.txt", slope);
	$readmemh("intercept.txt", intercept);
end

reg [3:0] addr;
wire [15:0]	xa, m, c, mx, y;
wire neg;

assign neg = x[15];
assign xa = neg ? (~x)+1 : x;

always @ (xa)
begin
	casex(xa)
	16'b0000_0000_0xxx_xxxx : addr <= 0;
	16'b0000_0000_1xxx_xxxx : addr <= 1;
	16'b0000_0001_0xxx_xxxx : addr <= 2;
	16'b0000_0001_1xxx_xxxx : addr <= 3;
	16'b0000_0010_0xxx_xxxx : addr <= 4;
	16'b0000_0010_1xxx_xxxx : addr <= 5;
	16'b0000_0011_0xxx_xxxx : addr <= 6;
	16'b0000_0011_1xxx_xxxx : addr <= 7;
	16'b0000_0100_0xxx_xxxx : addr <= 8;
	16'b0000_0100_1xxx_xxxx : addr <= 9;
	16'b0000_0101_0xxx_xxxx : addr <= 10;
	16'b0000_0101_1xxx_xxxx : addr <= 11;
	default : addr = 12;
	endcase
end

assign m = slope[addr];
assign c = intercept[addr];

Multiplier MX(
	.A(xa),
	.B(m),
	.AB(mx)
);

assign y = mx + c;
assign z = neg ? 16'h0100 - y : y;

endmodule // sigmoid