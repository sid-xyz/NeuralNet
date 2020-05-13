`timescale 1ns / 1ps

// Architecture Block
module Architecture #(parameter NX = 6, parameter NH = 6, parameter BITS = 32) (
	input								clk,		//Clock
	input								TR,			//Training Signal (from Control)
	input								VL,			//Validation Signal (from Control)
	input								END,		//Process Complete Signal (from Control)
	input	[NX-1:0][BITS-1:0]			x,			//Input vector (from Pattern)
	input	[BITS-1:0]					y,			//Output Label (from Pattern)
	input	[BITS-1:0]					lr,			//Learning Rate (from Pattern)
	output	[BITS-1:0]					yhat,
	output	[BITS-1:0]					Error,
	output								S_Train,	//Training Pattern Complete (to Control)
	output								S_Error,	//Validation Pattern Complete (to Control)
	output	[NH-1:0][NX:0][BITS-1:0]	WH,
	output	[NH:0][BITS-1:0]			WO
);

wire FPH, FPO, BPH, BPO;	// Forward, Backward propagation flags
wire [BITS-1:0] dz2;		// dz of output neuron

// Updated Weights
wire [NH-1:0][NX:0][BITS-1:0] WH;
wire [NH:0][BITS-1:0] WO;

// Weights
reg [NX:0][BITS-1:0] W1 [NH-1:0];
reg [NH:0][BITS-1:0] W2;

wire [NH-1:0][BITS-1:0] a1;		//Outputs of hidden layer
wire [BITS-1:0] a2;				//Output of output layer

ArchCTRL archControl(
	.clk(clk),
	.TR(TR),
	.VL(VL),
	.END(END),
	.FPH(FPH),
	.FPO(FPO),
	.BPH(BPH),
	.BPO(BPO),
	.S_Train(S_Train),
	.S_Error(S_Error)
);

assign Error = (y == yhat) ? 0 : 1;

initial begin
	//He Initialisation: randn * sqrt[2/n_(l-1)]
	$readmemh("w1h6_32.txt", W1);	//Hidden layer weights (generated using MATLAB randn)

	//Xavier Initialisation: randn * sqrt[1/n_(l-1)]
	//Output layer weights (generated using MATLAB randn)
	//W2 <= 112'h00a6_ffac_0049_0057_ffe7_0017__0000;
	W2 <= 224'hfffff0bc_ffffc866_0000afcd_ffffa47a_ffffcd70_ffffb596__00000000;
end

always @ (posedge clk) begin
	if (S_Train) begin
		// Update weights to new weights (gradient descent)
		W2 <= WO;		//Output layer
		// Hidden layer
		W1[0] <= WH[0];
		W1[1] <= WH[1];
		W1[2] <= WH[2];
		W1[3] <= WH[3];
		W1[4] <= WH[4];
		W1[5] <= WH[5];
	end
end

genvar i;
// Generate 'NH' number of neurons in the hidden layer
generate
	for (i = 0; i < NH; i = i+1) begin
		Neuron_ReLU #(.N(NX), .BITS(BITS)) HiddenUnit (
			.clk(clk),
			.FP(FPH),
			.BP(BPH),
			.x(x),
			.w(W1[i][NX:1]),
			.b(W1[i][0]),
			.dZ_in(dz2),
			.W_in(W2[i+1]),
			.lr(lr),
			.y(a1[i]),
			.W_out(WH[i])
		);
	end
endgenerate

Neuron_Sigmoid #(.N(NH), .BITS(BITS)) OutputUnit (
			.clk(clk),
			.FP(FPO),
			.BP(BPO),
			.x(a1),
			.w(W2[NH:1]),
			.b(W2[0]),
			.y_true(y),
			.lr(lr),
			.y(a2),
			.yhat(yhat),
			.dZ_out(dz2),
			.W_out(WO)
);

//
endmodule // Architecture