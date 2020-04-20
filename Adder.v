`timescale 1ns / 1ps

module Adder #(parameter BITS = 16) (
	input	[BITS-1:0]	A,
	input	[BITS-1:0]	B,
	output	[BITS-1:0]	C
);

assign C = A + B;

endmodule // Adder