`timescale 1ns / 1ps

//Pattern Block
module Pattern #(parameter NX = 6, NH = 30, BITS = 16) (
	input						clk,		//Clock
	input						TR,			//Training Signal (from Control)		
	input						VL,			//Validation Signal (from Control)
	input						SW,			//Store Weights signal (from Control)
	input						START,		//Process Start Signal (from Control)
	input						END,		//Process Complete Signal (from Control)
	input	[NX:0][BITS-1:0]	W1,			//Weights - hidden layer (from Architecture)
	input	[NH:0][BITS-1:0]	W2,			//Weights - output layer (from Architecture)
	output	[BITS-1:0]			lr,			//-Learning Rate (to Architecture)
	output	[NX-1:0][BITS-1:0]	x,			//Neural Network input (to Architecture)
	output	[BITS-1:0]			y,			//Output label (to Architecture)
	output	[BITS-1:0]			TRAIN,		//# Training samples (to Control)
	output	[BITS-1:0]			VALID,		//# Validation samples (to Control)
	output	[BITS-1:0]			EPOCH		//# Epochs (to Control)
);

// #Train, #Valid, #Epoch
parameter N_train = 533;
parameter N_validate = 177;
parameter N_Epochs = 1;

assign TRAIN = N_train;
assign VALID = N_validate;
assign EPOCH = N_Epochs;

// Training & Validation data
reg [NX-1:0][BITS-1:0]	X_train	[N_train-1:0];
reg 		[BITS-1:0]	Y_train	[N_train-1:0];
reg [NX-1:0][BITS-1:0]	X_val 	[N_validate-1:0];
reg 		[BITS-1:0] 	Y_val	[N_validate-1:0];

// NN Weights
reg	[NX:0][BITS-1:0]	WH;
reg	[NH:0][BITS-1:0]	WO;

reg [NX-1:0][BITS-1:0] dataX;	//NN input data
reg [BITS-1:0] dataY;			//Output label
reg [BITS-1:0] negLR;			//-learning rate
reg [15:0] addr_t, addr_v;		//iterators

initial begin
	$readmemh("xdata.txt", X_train);
	$readmemh("ydata.txt", Y_train);
	$readmemh("xval.txt", X_val);
	$readmemh("yval.txt", Y_val);
	negLR <= 16'hFF_00;
	addr_t <= 16'h0000;
	addr_v <= 16'h0000;
end

always @ (posedge clk) begin
	if (START | END) begin
		dataX <= X_train[0];
		dataY <= Y_train[0];
		addr_t <= 0;
		addr_v <= 0;
	end

	if (TR) begin					//Training
		dataX <= X_train[addr_t];
		dataY <= Y_train[addr_t];
		addr_t <= addr_t + 1;
		addr_v <= 0;
	end

	else if (VL) begin				//Validation
		dataX <= X_val[addr_v];
		dataY <= Y_val[addr_v];
		addr_v <= addr_v + 1;
		addr_t <= 0;
	end

	else if (SW) begin				//Store NN synaptic weights
		WH <= W1;
		WO <= W2;
		// addr_v <= 0;
		// addr_t <= 0;
	end
end

assign x = dataX;
assign y = dataY;
assign lr = negLR;

endmodule // Pattern