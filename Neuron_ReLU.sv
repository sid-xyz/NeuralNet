`timescale 1ns / 1ps

//Neuron with ReLU activation function (hidden layer)
module Neuron_ReLU #(parameter N = 6, parameter BITS = 16) (
	input						clk,		//Clock
	input						FP,			//Forward prop signal
	input						BP,			//Backprop signal
	input	[N-1:0][BITS-1:0]	x,			//Neuron inputs
	input	[N-1:0][BITS-1:0]	w,			//Synaptic weights
	input	[BITS-1:0]			b,			//Bias
	input	[BITS-1:0]			dZ_in,		//dz from next layer (output layer)
	input	[BITS-1:0]			W_in,		//weights from next layer
	input	[BITS-1:0]			lr,			// - Learning Rate (negative of lr)
	output	[BITS-1:0]			y,			//Neuron output
	output	[N:0][BITS-1:0]		W_out		//Updated weights
);

reg [4:0] itr1, itr2, itr3;		//iterators
reg INC;						//Flag for incrementing itr

//forward prop & backprop values
reg [BITS-1:0] ACT, OUT, dz;
reg [N-1:0][BITS-1:0] dw;
reg [N:0][BITS-1:0] WL;
wire [BITS-1:0] val;

//Multiplier & Adder Inputs & Outputs
wire [BITS-1:0] AB1, AB2, S1, S2;	//Mult, Adder outputs
reg [BITS-1:0] A1, B1, A2, B2;		//Mult inputs
reg [BITS-1:0] R1, R2, R3, R4;		//Adder inputs

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
	.z(val)
);

assign W_out = WL;	//Updated weights
assign y = OUT;		//Neuron output

always @ (posedge clk) begin
	if ({FP,BP} == 2'b00) begin					//Forward Setup
		itr1 = 5'b00000;
		itr2 = 5'b00001;
		itr3 = 5'b00000;
		INC <= 1'b1;
		A1 <= x[itr1];		//x * w
		B1 <= w[itr1];
		A2 <= x[itr2];
		B2 <= w[itr2];
		R1 <= 16'h00_00;
		R2 <= 16'h00_00;
		R3 <= 16'h00_00;
		R4 <= b;
	end

	else if ({FP,BP} == 2'b10) begin			//Forward Propagation
		INC <= (itr1 == N) ? 1'b0 : INC;
		itr1 = (INC) ? itr1 + 5'b00010 : 5'b00000;
		itr2 = (INC) ? itr1 + 1 : 0;
		A1 <= INC ? x[itr1] : 0;		//x * w
		B1 <= INC ? w[itr1] : 0;
		A2 <= INC ? x[itr2] : 0;
		B2 <= INC ? w[itr2] : 0;
		R1 <= AB1;						//sum(x*w)
		R2 <= AB2;
		R3 <= S1;
		R4 <= S2;
		ACT <= S2;		//Input of activation function
		OUT <= val;		//Output of activation function (& neuron)
	end

	else if ({FP,BP} == 2'b01) begin			//Backward Propagation
		//dz = (itr1 == 5'b00000) ? AB2 : dz;
		dz = (itr1 == 5'b00000) ? ((ACT[15]) ? 0 : AB2) : dz;
		itr1 <= itr1 + 5'b00001;
		itr2 <= itr1;
		itr3 <= itr2;
		A1 <= AB2;			//-LR * dw
		B1 <= lr;
		A2 <= dz;			//dz * x
		B2 <= x[itr1];
		R1 <= WL[itr2];		//w + (-LR * dw)
		R2 <= AB1;
		WL[itr3] <= S1;		//Weight update
	end

	else if ({FP,BP} == 2'b11) begin			//Backward Setup
		itr1 <= 5'b00000;
		itr2 <= 5'b00000;
		itr3 <= 5'b00000;
		INC <= 1'b1;
		A1 <= 16'h00_00;
		B1 <= 16'h00_00;
		A2 <= W_in;			//Calculate dz
		B2 <= dZ_in;
		R1 <= 16'h00_00;
		R2 <= 16'h00_00;
		R3 <= 16'h00_00;
		R4 <= 16'h00_00;
		WL <= {w, b};
	end
end

endmodule // Neuron_ReLU