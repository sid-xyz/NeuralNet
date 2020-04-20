`timescale 1ns / 1ps

module Neuron_Linear #(parameter N = 2, parameter B = 16)
(
	input	[N-1:0][B-1:0]	x,
	input	[N-1:0][B-1:0]	w,
	input	[B-1:0]			b,
	output	[B-1:0]			y
);

wire [15:0] x1w1, x2w2, out;

Multiplier M1(
	.A(x[0]),
	.B(w[0]),
	.AB(x1w1)
);

Multiplier M2(
	.A(x[1]),
	.B(w[1]),
	.AB(x2w2)
);

Adder A1(
	.A(x1w1),
	.B(x2w2),
	.C(out)
);

assign y = out + b;

endmodule // Neuron_Linear


// module Neuron_Sigmoid(
// 	input	[1:0][15:0]	x,
// 	input	[2:0][15:0]	w,
// 	output	[15:0]		y
// );

// wire [15:0] z;

// Neuron_Linear ActVal(
// 	.x(x),
// 	.w(w),
// 	.y(z)
// );

// Sigmoid sigmoidActFunc(
// 	.x(z),
// 	.z(y)
// );

// endmodule // Neuron_Sigmoid


// module Neuron_ReLU(
// 	input	[1:0][15:0]	x,
// 	input	[2:0][15:0]	w,
// 	output	[15:0]		y
// );

// wire [15:0] z;

// Neuron_Linear ActVal(
// 	.x(x),
// 	.w(w),
// 	.y(z)
// );

// ReLU reluActFunc(
// 	.x(z),
// 	.z(y)
// );

// endmodule // Neuron_ReLU