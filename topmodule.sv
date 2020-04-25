`timescale 1ns / 1ps

module TopModule #(parameter NX = 6, NH = 30, BITS = 16) (
	input	clk,
	input	START
);

wire TR, VL, SW, FIN, RST;
wire [BITS-1:0] TRAIN, VALID, EPOCH;
wire [BITS-1:0] Error;

wire [BITS-1:0] lr;

wire [NX:0][BITS-1:0] W1;
wire [NH:0][BITS-1:0] W2;

wire [NX-1:0][BITS-1:0] x;
wire [BITS-1:0] y, out;
wire S_Train, S_Error;


Control #(.BITS(BITS)) ControlBlock(
	.clk(clk),
	.TRAIN(TRAIN),
	.VALID(VALID),
	.EPOCH(EPOCH),
	.Error(Error),
	.S_Train(S_Train),
	.S_Error(S_Error),
	.Start(START),
	.TR(TR),
	.VL(VL),
	.SAVE(SW),
	.END(FIN)
);

Pattern #(.NX(NX), .NH(NH), .BITS(BITS)) PatternBlock(
	.clk(clk),
	.TR(TR),
	.VL(VL),
	.SW(SW),
	.START(START),
	.END(FIN),
	.W1(W1),
	.W2(W2),
	.lr(lr),
	.x(x),
	.y(y),
	.TRAIN(TRAIN),
	.VALID(VALID),
	.EPOCH(EPOCH)
);

Architecture #(.NX(NX), .NH(NH), .BITS(BITS)) ArchBlock(
	.clk(clk),
	.TR(TR),
	.VL(VL),
	.END(FIN),
	.x(x),
	.lr(lr),
	.y(y),
	.yhat(out),
	.Error(Error),
	.S_Train(S_Train),
	.S_Error(S_Error)
);
	
endmodule // TopModule