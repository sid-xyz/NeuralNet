`timescale 1ns / 1ps

module Architecture #(parameter NX = 6, parameter NH = 30, parameter BITS = 16) (
	input						clk,
	input						TR,
	input						VL,
	input	[NX-1:0][BITS-1:0]	x,
	input	[BITS-1:0]			lr,
	input	[BITS-1:0]			y,
	//output	[BITS-1:0]			yhat,
	output						yhat,
	output						S_Train,
	output						S_Error
);

wire FPH, FPO, BPH, BPO;	// Forward, Backward propagation
wire [BITS-1:0] dz2;
wire [NX:0][BITS-1:0] WH [NH-1:0];
wire [NH:0][BITS-1:0] WO;

reg [NX:0][BITS-1:0] W1 [NH-1:0];
reg [NH:0][BITS-1:0] W2;

//wire [BITS-1:0] a1h [NH-1:0];
//wire [NH-1:0][BITS-1:0] a1o;
wire [NH-1:0][BITS-1:0] a1;
wire [BITS-1:0] a2;

ArchCTRL archControl(
	.clk(clk),
	.TR(TR),
	.VL(VL),
	.FPH(FPH),
	.FPO(FPO),
	.BPH(BPH),
	.BPO(BPO),
	.S_Train(S_Train),
	.S_Error(S_Error)
);

initial begin
	$readmemh("w1.txt", W1);
	W2 <= 496'hffdc_ffe0_003c_ffda_ffc6_000a_005e_0001_000e_ffd4_004e_0006_0019_ffd4_0028_0012_ffca_0002_ffeb_0005_fff4_fff7_ffd0_fff1_0024_0052_ffca_006f_0047_0008__0000;
end

always @ (posedge clk) begin
	if (S_Train) begin
		W2 <= WO;
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

//assign a1o = { << {a1h}};

genvar i;
generate
	for (i=0; i < NH; i = i+1) begin
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