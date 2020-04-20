`timescale 1ns / 1ps

module Validation(
	input			clk,
	input	[15:0]	VAL,
	input	[15:0]	EPOCH,
	input	[15:0]	error,
	input			S_Error,
	input			VC
);

reg	[15:0]	countVAL, countEPC, min_Error, E_Epoch;
wire EC, SC;

initial begin
	countVAL = 16'h0000;
	countEPC = 16'h0000;
	E_Epoch = 16'h0000;
	min_Error = 16'h7F_FF;
end

assign EC = (countVAL == VAL);
assign SC = (countEPC == EPOCH);

always @ (posedge clk) begin
	if (VC & S_Error) begin
		countVAL = countVAL + 16'h0001;
		E_Epoch <= E_Epoch + error;
	end

	else if (EC) begin
		if (E_Epoch < min_Error) begin
		min_Error <= E_Epoch;
		//Store Network
		end

		countVAL <= 16'h0000;
		countEPC <= countEPC + 16'h0001;
		E_Epoch <= 16'h0000;
	end

	else if (SC) begin
		// Send Stored Network

		//End
	end
end

endmodule // Validation