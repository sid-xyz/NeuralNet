`timescale 1ns / 1ps

module top_TB ();

reg clk, START;

TopModule #(.NX(6), .NH(6), .BITS(32)) myTop(
	.clk(clk),
	.START(START)
);

initial begin
	$dumpfile("top6h.vcd");
	$dumpvars(0,top_TB);
	clk <= 1'b0;
	START <= 1'b0;
end

always #10 clk <= ~clk;

always #25928500 $finish;

always begin
	#10 START <= 1'b1;
	#20 START <= 1'b0;
	#25928500 ;
end

endmodule