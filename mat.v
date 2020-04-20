`timescale 1ns / 1ps

module Mult_Test();

reg [15:0] A, B;
wire [15:0] out;

Multiplier myMult(
	.A(A),
	.B(B),
	.AB(out)
);

initial begin
	$dumpfile("mult.vcd");
	$dumpvars(0, Mult_Test);
	A <= 16'h02_00;
	B <= 16'hFC_FF;
end

always #10 $stop;

endmodule // Mult_Test