`timescale 1ns / 1ps

module Neuron_ReLU #(parameter N = 6, parameter BITS = 16) (
	input						clk,
	input						FP,
	input						BP,
	input	[N-1:0][BITS-1:0]	x,
	input	[N-1:0][BITS-1:0]	w,
	input	[BITS-1:0]			b,
	input	[BITS-1:0]			dZ_in,
	input	[BITS-1:0]			W_in,
	input	[BITS-1:0]			lr,
	output	[BITS-1:0]			y
	//output	[BITS:0]			W_out
);

reg [4:0] itr1, itr2, itr3;
reg INC;
reg [BITS-1:0] ACT, OUT, dz;
reg [N-1:0][BITS-1:0] dw;
reg [N:0][BITS-1:0] WL;

wire [BITS-1:0] AB1, AB2, S1, S2;
reg [BITS-1:0] A1, B1, A2, B2;
reg [BITS-1:0] R1, R2, R3, R4;

//assign W_out = WL;

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
	.C(S1)
);

Adder AD2(
	.A(R3),
	.B(R4),
	.C(S2)
);

ReLU reluActFunc(
	.x(S2),
	.z(y)
);

always @ (posedge clk) begin
	if ({FP,BP} == 2'b00) begin						//Forward Setup
		itr1 = 5'b00000;
		itr2 = 5'b00001;
		itr3 = 5'b00000;
		INC <= 1'b1;
		A1 <= x[itr1];
		B1 <= w[itr1];
		A2 <= x[itr2];
		B2 <= w[itr2];
		R1 <= 16'h00_00;
		R2 <= 16'h00_00;
		R3 <= 16'h00_00;
		R4 <= b;
	end

	else if ({FP,BP} == 2'b10) begin				//Forward Propagation
		INC <= (itr1 == N) ? 1'b0 : INC;
		itr1 = (INC) ? itr1 + 5'b00010 : 5'b00000;
		itr2 = (INC) ? itr1 + 1 : 0;
		A1 <= INC ? x[itr1] : 0;
		B1 <= INC ? w[itr1] : 0;
		A2 <= INC ? x[itr2] : 0;
		B2 <= INC ? w[itr2] : 0;
		R1 <= AB1;
		R2 <= AB2;
		R3 <= S1;
		R4 <= S2;
		ACT <= S2;
		OUT <= y;
	end

	else if ({FP,BP} == 2'b01) begin				//Backward Propagation
		//dz = (itr1 == 5'b00000) ? AB2 : dz;
		dz <= (itr1 == 5'b11111) ? ((ACT[15]) ? 0 : AB2) : dz;
		itr1 <= itr1 + 5'b00001;
		itr2 <= itr1;
		itr3 <= itr2;
		A1 <= AB2;
		B1 <= lr;
		A2 <= dz;
		B2 <= x[itr1];
		R1 <= WL[itr2];
		R2 <= AB1;
		WL[itr3] <= S1;
	end

	else if ({FP,BP} == 2'b11) begin				//Backward Setup
		itr1 <= 5'b00000;
		itr2 <= 5'b00000;
		itr3 <= 5'b00000;
		INC <= 1'b1;
		A1 <= 16'h00_00;
		B1 <= 16'h00_00;
		A2 <= W_in;
		B2 <= dZ_in;
		R1 <= 16'h00_00;
		R2 <= 16'h00_00;
		R3 <= 16'h00_00;
		R4 <= 16'h00_00;
		WL <= {w, b};
		XL <= {x, 16'h0100};
	end
end

endmodule // Neuron_ReLU