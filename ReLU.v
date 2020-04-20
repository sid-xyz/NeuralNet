`timescale 1ns / 1ps

module ReLU #(parameter BITS = 16) (
	input	[BITS-1:0]	x,
	output	[BITS-1:0]	z
);

assign z = x[BITS-1] ? 0 : x;

endmodule // relu