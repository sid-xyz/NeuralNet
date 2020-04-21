module Sigmoid_16(
	input	[15:0]	x,
	output	[15:0]	z
);

reg [15:0] slope [12:0];
reg [15:0] intercept [12:0];
initial begin
	$readmemh("slope16.txt", slope);
	$readmemh("intercept16.txt", intercept);
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

Multiplier #(.BITS(16)) MX(
	.A(xa),
	.B(m),
	.AB(mx)
);

assign y = mx + c;
assign z = neg ? 16'h0100 - y : y;

endmodule // sigmoid


module Sigmoid_32(
	input	[31:0]	x,
	output	[31:0]	z
);

reg [31:0] slope [12:0];
reg [31:0] intercept [12:0];
initial begin
	$readmemh("slope32.txt", slope);
	$readmemh("intercept32.txt", intercept);
end

reg [3:0] addr;
wire [31:0]	xa, m, c, mx, y;
wire neg;

assign neg = x[31];
assign xa = neg ? (~x)+1 : x;

always @ (xa)
begin
	casex(xa)
	32'b0000_0000_0000_0000__0xxx_xxxx_xxxx_xxxx : addr <= 0;
	32'b0000_0000_0000_0000__1xxx_xxxx_xxxx_xxxx : addr <= 1;
	32'b0000_0000_0000_0001__0xxx_xxxx_xxxx_xxxx : addr <= 2;
	32'b0000_0000_0000_0001__1xxx_xxxx_xxxx_xxxx : addr <= 3;
	32'b0000_0000_0000_0010__0xxx_xxxx_xxxx_xxxx : addr <= 4;
	32'b0000_0000_0000_0010__1xxx_xxxx_xxxx_xxxx : addr <= 5;
	32'b0000_0000_0000_0011__0xxx_xxxx_xxxx_xxxx : addr <= 6;
	32'b0000_0000_0000_0011__1xxx_xxxx_xxxx_xxxx : addr <= 7;
	32'b0000_0000_0000_0100__0xxx_xxxx_xxxx_xxxx : addr <= 8;
	32'b0000_0000_0000_0100__1xxx_xxxx_xxxx_xxxx : addr <= 9;
	32'b0000_0000_0000_0101__0xxx_xxxx_xxxx_xxxx : addr <= 10;
	32'b0000_0000_0000_0101__1xxx_xxxx_xxxx_xxxx : addr <= 11;
	default : addr = 12;
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

endmodule // sigmoid

// module sigmoid_tb();
// reg [15:0] in;
// wire [15:0] out;

// Sigmoid act1(
// 	.x(in),
// 	.z(out)
// );

// initial begin
// 	$dumpfile("sigmoid.vcd");
// 	$dumpvars(0, sigmoid_tb);
// 	in <= 16'hF8_F9;
// end

// always #10 in <= in + 16'h02_00;
// always #80 $stop;

// endmodule // sigmoid_tb