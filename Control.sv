`timescale 1ns / 1ps

module Control #(parameter BITS = 16) (
	input				clk,
	input	[BITS-1:0]	TRAIN,
	input	[BITS-1:0]	VALID,
	input	[BITS-1:0]	EPOCH,
	input	[BITS-1:0]	Error,
	input				S_Train,
	input				S_Error,
	input				Start,
	output				TR,
	output				VL,
	output				SAVE,
	output				END
);

reg NT, NV, SW, RST, FIN;
reg [BITS-1:0] E_Epoch, E_Min;
reg [BITS-1:0] countTR, countVL, countEP;

wire T_FL, V_FL, E_FL;

assign T_FL = (countTR == TRAIN);
assign V_FL = (countVL == VALID);
assign E_FL = (countEP == EPOCH);

assign TR = NT;
assign VL = NV;
assign SAVE = SW;
assign END = FIN;

initial begin
	NT <= 1'b0;
	NV <= 1'b0;
	SW <= 1'b0;
	E_Epoch <= 0;
	E_Min <= 16'h7F_FF;
	countTR <= 0;
	countVL <= 0;
	countEP <= 0;
	FIN <= 0;
end

always @ (posedge clk) begin
	if (Start | RST) begin
		NT <= 1'b1;
		NV <= 1'b0;
		SW <= 1'b0;
		countTR <= 1;
		countVL <= 0;
		E_Epoch <= 0;
		RST <= 1'b0;
		FIN <= 0;
	end

	else if (S_Train & ~T_FL) begin
		countTR <= countTR + 1;
		NT <= 1'b1;
		NV <= 1'b0;
		SW <= 1'b0;
	end

	else if (NT) begin
		NT <= 1'b0;
	end
	
	else if (T_FL & (S_Train | S_Error & ~V_FL)) begin
		countVL <= countVL + 1;
		NV <= 1'b1;
		NT <= 1'b0;
		SW <= 1'b0;
		if (S_Error) begin
			E_Epoch <= E_Epoch + Error;
		end
	end

	else if (NV) begin
		NV <= 1'b0;
	end

	else if (T_FL & V_FL & S_Error & ~E_FL) begin
		countEP <= countEP + 1;
		NT <= 0;
		NV <= 0;
		if (E_Epoch < E_Min) begin
			E_Min <= E_Epoch;
			SW <= 1'b1;
		end
		RST <= 1'b1;
		countTR <= 0;
		countVL <= 0;
	end

	if (E_FL) begin
		FIN <= 1'b1;
		countTR <= 0;
		countVL <= 0;
		countEP <= 0;
		NT <= 1'b0;
		NV <= 1'b0;
		SW <= 1'b0;
	end
end

endmodule