`timescale 1ns / 1ps

//Q15.16 Approximation of Sigmoid function (linear interpolation)
module Sigmoid_32(
	input	[31:0]	x,
	output	[31:0]	z
);

reg [31:0] slope [32:0];
reg [31:0] intercept [32:0];
initial begin
	$readmemh("slope32.txt", slope);
	$readmemh("intercept32.txt", intercept);
end

reg [3:0] addr;
wire [31:0]	xa, m, c, mx, y;
wire neg;

//Sigmoid(-x) = 1 - Sigmoid(x)
assign neg = x[31];
assign xa = neg ? (~x)+1 : x;

always @ (xa)
begin
	casex(xa)
	32'b0000_0000_0000_0000__00xx_xxxx_xxxx_xxxx : addr <= 0;
	32'b0000_0000_0000_0000__01xx_xxxx_xxxx_xxxx : addr <= 1;
	32'b0000_0000_0000_0000__10xx_xxxx_xxxx_xxxx : addr <= 2;
	32'b0000_0000_0000_0000__11xx_xxxx_xxxx_xxxx : addr <= 3;
	32'b0000_0000_0000_0001__00xx_xxxx_xxxx_xxxx : addr <= 4;
	32'b0000_0000_0000_0001__01xx_xxxx_xxxx_xxxx : addr <= 5;
	32'b0000_0000_0000_0001__10xx_xxxx_xxxx_xxxx : addr <= 6;
	32'b0000_0000_0000_0001__11xx_xxxx_xxxx_xxxx : addr <= 7;
	32'b0000_0000_0000_0010__00xx_xxxx_xxxx_xxxx : addr <= 8;
	32'b0000_0000_0000_0010__01xx_xxxx_xxxx_xxxx : addr <= 9;
	32'b0000_0000_0000_0010__10xx_xxxx_xxxx_xxxx : addr <= 10;
	32'b0000_0000_0000_0010__11xx_xxxx_xxxx_xxxx : addr <= 11;
	32'b0000_0000_0000_0011__00xx_xxxx_xxxx_xxxx : addr <= 12;
	32'b0000_0000_0000_0011__01xx_xxxx_xxxx_xxxx : addr <= 13;
	32'b0000_0000_0000_0011__10xx_xxxx_xxxx_xxxx : addr <= 14;
	32'b0000_0000_0000_0011__11xx_xxxx_xxxx_xxxx : addr <= 15;
	32'b0000_0000_0000_0100__00xx_xxxx_xxxx_xxxx : addr <= 16;
	32'b0000_0000_0000_0100__01xx_xxxx_xxxx_xxxx : addr <= 17;
	32'b0000_0000_0000_0100__10xx_xxxx_xxxx_xxxx : addr <= 18;
	32'b0000_0000_0000_0100__11xx_xxxx_xxxx_xxxx : addr <= 19;
	32'b0000_0000_0000_0101__00xx_xxxx_xxxx_xxxx : addr <= 20;
	32'b0000_0000_0000_0101__01xx_xxxx_xxxx_xxxx : addr <= 21;
	32'b0000_0000_0000_0101__10xx_xxxx_xxxx_xxxx : addr <= 22;
	32'b0000_0000_0000_0101__11xx_xxxx_xxxx_xxxx : addr <= 23;
	32'b0000_0000_0000_0110__00xx_xxxx_xxxx_xxxx : addr <= 24;
	32'b0000_0000_0000_0110__01xx_xxxx_xxxx_xxxx : addr <= 25;
	32'b0000_0000_0000_0110__10xx_xxxx_xxxx_xxxx : addr <= 26;
	32'b0000_0000_0000_0110__11xx_xxxx_xxxx_xxxx : addr <= 27;
	32'b0000_0000_0000_0111__00xx_xxxx_xxxx_xxxx : addr <= 28;
	32'b0000_0000_0000_0111__01xx_xxxx_xxxx_xxxx : addr <= 29;
	32'b0000_0000_0000_0111__10xx_xxxx_xxxx_xxxx : addr <= 30;
	32'b0000_0000_0000_0111__11xx_xxxx_xxxx_xxxx : addr <= 31;
	default: addr <= 32;
	endcase
end

assign m = slope[addr];
assign c = intercept[addr];

Multiplier #(.BITS(32)) MX(
	.A(xa),
	.B(m),
	.AB(mx)
);

assign y = mx + c;
assign z = neg ? 32'h0001_0000 - y : y;

endmodule // Sigmoid_32