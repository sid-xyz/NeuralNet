`timescale 1ns / 1ps

module Control_TB ();

parameter B = 16;

reg clk;	
reg [B-1:0] TRAIN, VALID, EPOCH;
reg [B-1:0] ERR;
reg ST, SE, START;
wire TR, VL, SW;
	
	
Control #(.BITS(B)) CB(
	.clk(clk),
	.TRAIN(TRAIN),
	.VALID(VALID),
	.EPOCH(EPOCH),
	.Error(ERR),
	.S_Train(ST),
	.S_Error(SE),
	.Start(START),
	.TR(TR),
	.VL(VL),
	.SAVE(SW)
);

initial begin
	$dumpfile("control.vcd");
	$dumpvars(0, Control_TB);
	clk <= 1'b0;
	ST <= 1'b0;
	SE <= 1'b0;
	START <= 1'b0;
	ERR <= 16'h0000;
	TRAIN <= 16'h000A;
	VALID <= 16'h000A;
	EPOCH <= 16'h0002;
	TX <= 1'b0;
end

always #10 clk <= ~clk;

always begin
	#10 START <= 1'b1;
	#20 START <= 1'b0;
	#2970 $stop;
end

always @ (posedge clk) begin
if (~TX) begin
	ST <= ~ST;
end
end

reg TX;
always #450 TX <= 1'b1;

always @ (posedge clk) begin
if (TX) begin
	SE <= ~SE;
end
end

always #40 ERR <= ERR + 16'h0002;

endmodule // Control_TB