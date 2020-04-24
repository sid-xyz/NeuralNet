`timescale 1ns / 1ps

module Neuron_Linear #(parameter N = 2, parameter BITS = 16) (
	input						clk,
	input						FP,
	//input						BP,
	input	[N-1:0][BITS-1:0]	x,
	input	[N-1:0][BITS-1:0]	w,
	input	[BITS-1:0]			b,
	output	[BITS-1:0]			y
);

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

always @ (posedge clk) begin
	if (FP) begin
		R1 <= AB1;
		R2 <= AB2;
		R3 <= P1;
		R4 <= P2;
	end
end

always @ (posedge FP, negedge FP) begin
	A1 <= x[0];
	B1 <= w[0];
	A2 <= x[1];
	B2 <= w[1];
	R1 <= 16'h00_00;
	R2 <= 16'h00_00;
	R3 <= 16'h00_00;
	R4 <= b;
end

assign y = R4;

endmodule // Neuron_Linear