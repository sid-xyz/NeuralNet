`timescale 1ns / 1ps

module Neuron_Sigmoid #(parameter N = 2, parameter BITS = 16) (
	input						clk,
	input						FP,
	input						BP,
	input	[N-1:0][BITS-1:0]	x,
	input	[N-1:0][BITS-1:0]	w,
	input	[BITS-1:0]			b,
	input	[BITS-1:0]			y_true,
	output	[BITS-1:0]			y,
	output	[BITS-1:0]			dZ
);

reg [4:0] iter, itr2;
reg INC;
reg [BITS-1:0] ACT, OUT, dz;
reg [N-1:0][BITS-1:0] dw;

wire [BITS-1:0] AB1, AB2, P1, P2;
reg [BITS-1:0] A1, B1, A2, B2;
reg [BITS-1:0] R1, R2, R3, R4;

Multiplier M1(
	.A(A1),
	.B(B1),
	.AB(AB1)
);

Multiplier M2(
	.A(A2),
	.B(B2),
	.AB(AB2)
);

Adder AD1(
	.A(R1),
	.B(R2),
	.C(P1)
);

Adder AD2(
	.A(R3),
	.B(R4),
	.C(P2)
);

Sigmoid sigmoidActFunc(
	.x(P2),
	.z(y)
);

always @ (posedge clk) begin
	if ({FP,BP} == 2'b10) begin
		iter = (INC) ? iter + 5'b00010 : 5'b00000;
		INC = (iter == N) ? 1'b0 : INC;
		A1 <= INC ? x[iter] : 0;
		B1 <= INC ? w[iter] : 0;
		A2 <= INC ? x[iter+1] : 0;
		B2 <= INC ? w[iter+1] : 0;
		R1 <= AB1;
		R2 <= AB2;
		R3 <= P1;
		R4 <= P2;
		ACT <= P2;
		OUT <= y;
	end

	if ({FP,BP} == 2'b01) begin
		dw[itr2] <= AB1;
		dw[itr2+1] <= AB2;
		dz <= P1;
		A1 <= P1;
		A2 <= P1;
		iter = (INC) ? iter + 5'b00010 : 5'b00000;
		INC = (iter == N) ? 1'b0 : INC;
		itr2 <= iter;
		B1 <= x[iter];
		B2 <= x[iter+1];
	end
end

assign dZ = dz;

always @ (posedge FP) begin
	iter = 5'b00000;
	INC <= 1'b1;
	A1 <= x[iter];
	B1 <= w[iter];
	A2 <= x[iter+1];
	B2 <= w[iter+1];
	R1 <= 16'h00_00;
	R2 <= 16'h00_00;
	R3 <= 16'h00_00;
	R4 <= b;
end

always @ (posedge BP) begin
	iter <= 5'b11110;
	itr2 <= 5'b00000;
	INC <= 1'b1;
	A1 <= 16'h00_00;
	B1 <= 16'h00_00;
	A2 <= 16'h00_00;
	B2 <= 16'h00_00;
	R1 <= OUT;
	R2 <= (~y_true) + 1;
	R3 <= 16'h00_00;
	R4 <= 16'h00_00;
end

endmodule