`timescale 1ns / 1ps

// Architecture Block
module Architecture #(parameter NX = 6, parameter NH = 30, parameter BITS = 16) (
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
	$readmemh("w1.txt", W1);	//Hidden layer weights (generated using MATLAB randn)

	//Xavier Initialisation: randn * sqrt[1/n_(l-1)]
	//Output layer weights (generated using MATLAB randn)
	W2 <= 496'hffdc_ffe0_003c_ffda_ffc6_000a_005e_0001_000e_ffd4_004e_0006_0019_ffd4_0028_0012_ffca_0002_ffeb_0005_fff4_fff7_ffd0_fff1_0024_0052_ffca_006f_0047_0008__0000;
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
		W1[6] <= WH[6];
		W1[7] <= WH[7];
		W1[8] <= WH[8];
		W1[9] <= WH[9];
		W1[10] <= WH[10];
		W1[11] <= WH[11];
		W1[12] <= WH[12];
		W1[13] <= WH[13];
		W1[14] <= WH[14];
		W1[15] <= WH[15];
		W1[16] <= WH[16];
		W1[17] <= WH[17];
		W1[18] <= WH[18];
		W1[19] <= WH[19];
		W1[20] <= WH[20];
		W1[21] <= WH[21];
		W1[22] <= WH[22];
		W1[23] <= WH[23];
		W1[24] <= WH[24];
		W1[25] <= WH[25];
		W1[26] <= WH[26];
		W1[27] <= WH[27];
		W1[28] <= WH[28];
		W1[29] <= WH[29];
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

endmodule // Architecture