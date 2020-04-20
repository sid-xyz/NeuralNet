`timescale 1ns / 1ps

module Neuron_Linear(
	input	[1:0][15:0]	x,
	input	[2:0][15:0]	w,
	output	[15:0]		y
);

wire [15:0] x1w1, x2w2, out;

Multiplier M1(
	.A(x[0]),
	.B(w[1]),
	.AB(x1w1)
);

Multiplier M2(
	.A(x[1]),
	.B(w[2]),
	.AB(x2w2)
);

Adder A1(
	.A(x1w1),
	.B(x2w2),
	.C(out)
);

assign y = out + w[0];

endmodule // Neuron_Linear