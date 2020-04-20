`timescale 1ns / 1ps

module NN_TB();

reg [1:0][15:0] x;
reg [2:0][15:0] w1, w2, v;
wire [15:0] y;

Network NN(
	.x(x),
	.w1(w1),
	.w2(w2),
	.v(v),
	.y(y)
);

initial begin
	$dumpfile("nnet.vcd");
	$dumpvars(0, NN_TB);
	x[0] <= 16'hFE_EF;
	x[1] <= 16'h02_00;
	w1[0] <= 16'h01_20;
	w1[1] <= 16'h04_00;
	w1[2] <= 16'h05_05;
	w2[0] <= 16'h00_A7;
	w2[1] <= 16'hFD_00;
	w2[2] <= 16'h02_10;
	v[0] <= 16'h00_80;
	v[1] <= 16'hFF_00;
	v[2] <= 16'h01_00;
end

always #10 $stop;

endmodule // NN_TB



// module Neuron_TB();

// reg [1:0][15:0] x;
// reg [2:0][15:0] w;
// wire [15:0] out;

// Neuron_Linear one(
// 	.x(x),
// 	.w(w),
// 	.y(out)
// );

// initial begin
// 	$dumpfile("neuron.vcd");
// 	$dumpvars(0, Neuron_TB);
// 	x[0] <= 16'hFE_EF;
// 	x[1] <= 16'h02_01;
// 	w[0] <= 16'h04_00;
// 	w[1] <= 16'hFD_00;
// 	w[2] <= 16'h00_00;
// end

// always #10 $stop;

// endmodule // Neuron_TB