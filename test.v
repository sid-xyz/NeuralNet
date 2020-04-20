`timescale 1ns / 1ps

// module NN_TB();

// reg [1:0][15:0] x;
// reg [2:0][15:0] w1, w2, v;
// wire [15:0] y;

// Network NN(
// 	.x(x),
// 	.w1(w1),
// 	.w2(w2),
// 	.v(v),
// 	.y(y)
// );

// initial begin
// 	$dumpfile("nnet.vcd");
// 	$dumpvars(0, NN_TB);
// 	x[0] <= 16'hFE_EF;
// 	x[1] <= 16'h02_00;
// 	w1[0] <= 16'h01_20;
// 	w1[1] <= 16'h04_00;
// 	w1[2] <= 16'h05_05;
// 	w2[0] <= 16'h00_A7;
// 	w2[1] <= 16'hFD_00;
// 	w2[2] <= 16'h02_10;
// 	v[0] <= 16'h00_80;
// 	v[1] <= 16'hFF_00;
// 	v[2] <= 16'h01_00;
// end

// always #10 $stop;

// endmodule // NN_TB



module Neuron_TB();

parameter N = 6;
parameter B = 16;

reg clk, TR, VL;
wire FPH, FPO, BPH, BPO;
reg [N-1:0][B-1:0] x;
reg [N-1:0][B-1:0] w;
reg [B-1:0] b;
wire [B-1:0] out, dz2;

// Neuron_ReLU #(.N(6), .BITS(16)) one(
// 	.clk(clk),
// 	.x(x),
// 	.w(w),
// 	.b(b),
// 	.FP(FPH),
// 	.BP(BPH),
// 	.dZ_in(16'h01_00),
// 	.W_in(16'h00_80),
// 	.lr(16'h01_00),
// 	.y(out)
// );

Neuron_Sigmoid #(.N(N), .BITS(B)) one(
	.clk(clk),
	.x(x),
	.w(w),
	.b(b),
	.FP(FPH),
	.BP(BPH),
	.y_true(16'h00_00),
	.lr(16'hFF_00),
	.y(out),
	.dZ(dz2)
);

ArchCTRL myAC(
	.clk(clk),
	.TR(TR),
	.VL(VL),
	.FPH(FPH),
	.FPO(FPO),
	.BPH(BPH),
	.BPO(BPO)
);

initial begin
	$dumpfile("neuron.vcd");
	$dumpvars(0, Neuron_TB);
	clk <= 1'b0;
	x[0] <= 16'hFE_EF;
	x[1] <= 16'h02_01;
	x[2] <= 16'h01_00;
	x[3] <= 16'h01_00;
	x[4] <= 16'h01_00;
	x[5] <= 16'h01_00;
	b <= 16'h00_00;
	w[0] <= 16'h04_00;
	w[1] <= 16'hFD_00;
	w[2] <= 16'h01_00;
	w[3] <= 16'h01_00;
	w[4] <= 16'h01_00;
	w[5] <= 16'h01_00;
	TR <= 1'b0;
	VL <= 1'b0;
end

always #10 clk <= ~clk;

always begin
	#10 TR <= 1'b1;
	#20 TR <= 1'b0;
	#1080 ;
	#20 VL <= 1'b1;
	#20 VL <= 1'b0;
	#440 ;
	#20 $stop;
end

endmodule // Neuron_TB