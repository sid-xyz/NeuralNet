`timescale 1ns / 1ps

// module mult_tb();
// reg clk;
// reg [15:0] A, B;
// wire [15:0] out;

// initial begin
// 	$dumpfile("one.vcd");
// 	$dumpvars(0, mult_tb);
// 	clk = 1'b0;
// 	A <= 16'h02_00;
// 	B <= 16'hFD_00;
// end

// mult M1(
// 	.clk(clk),
// 	.A(A),
// 	.B(B),
// 	.AB(out)
// );

// always #10 clk = ~clk;

// always begin
// 	#25 A <= 16'hFC_00;
// 	B <= 16'hFF_00;
// end

// always begin
// 	#40 A <= 16'hFC_00;
// 	B <= 16'h01_00;
// end

// always #100 $finish;

// endmodule // mult_tb

// module mult(
// 	input			clk,
//     input   [15:0]  A,
//     input   [15:0]  B,
//     output  [15:0]  AB
// );

// wire [31:0] mult;
// reg [15:0] Ax, Bx;

// always @ (posedge clk) begin
// 	Ax <= (B[15]) ? (~A)+1 : A;
// 	Bx <= (B[15]) ? (~B)+1 : B;
// end

// // assign Bx = (B[15]) ? (~B)+1 : B;
// // assign Ax = (B[15]) ? (~A)+1 : A;
// assign mult = Ax * Bx;
// assign AB = mult[23:8];

// endmodule // Multiplier


module AC_TB();
reg clk, TR, VL;
wire FPH, FPO, BPH, BPO;

initial begin
	$dumpfile("arch.vcd");
	$dumpvars(0, AC_TB);
	clk <= 1'b0;
	TR <= 1'b1;
	VL <= 1'b0;
end

ArchCTRL myAC(
	.clk(clk),
	.TR(TR),
	.VL(VL),
	.FPH(FPH),
	.FPO(FPO),
	.BPH(BPH),
	.BPO(BPO)
);

always #10 clk <= ~clk;

always begin
	#10 TR <= 1'b1;
	#20 TR <= 1'b0;
	#1080 ;
	#20 VL <= 1'b1;
	#20 VL <= 1'b0;
	#440 ;
	#20 $finish;
end

endmodule // AC_TB