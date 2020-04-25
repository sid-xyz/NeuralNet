`timescale 1ns / 1ps

module Pattern_TB();

parameter nx = 4;
parameter nh = 6;
parameter wordlen = 16;

reg clk;
reg TR, VL, SW;
reg [nx:0][wordlen-1:0] W1;
reg [nh:0][wordlen-1:0] W2;

wire [wordlen-1:0] lr;
wire [nx-1:0][wordlen-1:0] x;
wire [wordlen-1:0] y;
wire [wordlen-1:0] TRAIN, VALID, EPOCH;

Pattern #(.NX(nx), .NH(nh), .BITS(wordlen)) PB(
	.clk(clk),
	.TR(TR),
	.VL(VL),
	.SW(SW),
	.W1(W1),
	.W2(W2),
	.lr(lr),
	.x(x),
	.y(y),
	.TRAIN(TRAIN),
	.VALID(VALID),
	.EPOCH(EPOCH)
);

initial begin
	$dumpfile("pattern.vcd");
	$dumpvars(0, Pattern_TB);
	clk <= 1'b0;
	TR <= 1'b0;
	VL <= 1'b0;
	SW <= 1'b0;
end

always #10 clk <= ~ clk;

always begin
	#10 TR <= 1'b1;
	#20 TR <= 1'b0;
	#40 TR <= 1'b1;
	#20 TR <= 1'b0;
	#40 TR <= 1'b1;
	#20 TR <= 1'b0;
	#40 TR <= 1'b1;
	#20 TR <= 1'b0;
	#60 VL <= 1'b1;
	#20 VL <= 1'b0;
	#60 VL <= 1'b1;
	#20 VL <= 1'b0;
	#60 VL <= 1'b1;
	#20 VL <= 1'b0;
	#40 VL <= 1'b1;
	#20 VL <= 1'b0;
	#40 TR <= 1'b1;
	#20 TR <= 1'b0;
	#20 VL <= 1'b1;
	#20 VL <= 1'b0;
	#30 $finish;
end

endmodule // Pattern_TB