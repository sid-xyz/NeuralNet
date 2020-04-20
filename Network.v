`timescale 1ns / 1ps

module Network(
	input	[1:0][15:0]	x,
	input	[2:0][15:0]	w1,
	input	[2:0][15:0]	w2,
	input	[2:0][15:0]	v,
	output	[15:0]		y
);

wire [1:0][15:0] z;

Neuron_Linear HL1(
	.x(x),
	.w(w1),
	.y(z[0])
);

Neuron_Linear HL2(
	.x(x),
	.w(w2),
	.y(z[1])
);

Neuron_Linear OUT(
	.x(z),
	.w(v),
	.y(y)
);

endmodule // NNet