`timescale 1ns / 1ps

module Adder(
	input	[15:0]	A,
	input	[15:0]	B,
	output	[15:0]	C
);

assign C = A + B;

endmodule // Adder