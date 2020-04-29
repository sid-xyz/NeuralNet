`timescale 1ns / 1ps

module top_TB ();

reg clk, START;

TopModule #(.NX(6), .NH(30), .BITS(16)) myTop(
	.clk(clk),
	.START(START)
);

initial begin
	$dumpfile("top.vcd");
	$dumpvars(0,top_TB);
	clk <= 1'b0;
	START <= 1'b0;
end

always #10 clk <= ~clk;

always #70326050 $finish;

always begin
	#10 START <= 1'b1;
	#20 START <= 1'b0;
	//#69999970 ;
	#70326020 ;
end

endmodule