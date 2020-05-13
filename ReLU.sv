`timescale 1ns / 1ps

// Rectified Linear Unit activation function
module ReLU #(parameter BITS = 32) (
	input	[BITS-1:0]	x,
	output	[BITS-1:0]	z
);

//ReLU (x) = max{0, x}
assign z = x[BITS-1] ? 0 : x;

endmodule // relu