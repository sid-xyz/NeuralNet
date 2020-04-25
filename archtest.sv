`timescale 1ns / 1ps

module Arch_TB();
reg clk;

parameter NX = 6;
parameter NH = 30;
parameter B = 16;

reg T, V;
reg [NX-1:0][B-1:0] in;
//wire [B-1:0] out;
wire out;
wire ST, SE;


Architecture #(.NX(NX), .NH(NH), .BITS(B)) AB(
	.clk(clk),
	.TR(T),
	.VL(V),
	.x(in),
	.lr(16'h00_02),
	.y(16'h01_00),
	.yhat(out),
	.S_Train(ST),
	.S_Error(SE)
);

initial begin
	$dumpfile("arch.vcd");
	$dumpvars(0, Arch_TB);
	clk <= 1'b0;
	T <= 1'b0;
	V <= 1'b0;
	in[0] <= 16'hFE_EF;
	in[1] <= 16'h02_01;
	in[2] <= 16'h01_00;
	in[3] <= 16'h01_00;
	in[4] <= 16'h01_00;
	in[5] <= 16'h01_00;
end

always #10 clk <= ~clk;

always begin
	#20 T <= 1'b1;
	#20 T <= 1'b0;
	#1150 ;
	#20 $finish;
end

endmodule // Arch_TB