`timescale 1ns / 1ps

module ArchCTRL(
	input	clk,
	input	TR,
	input	VL,
	input	END,
	output	FPH,
	output	FPO,
	output	BPH,
	output	BPO,
	output	S_Train,
	output	S_Error
);

reg [5:0] count;
reg [3:0] Signal;
reg [1:0] TV;
reg ST, SE, reset;

assign {FPH, FPO, BPH, BPO} = Signal;
assign S_Train = ST;
assign S_Error = SE;

initial begin
	count <= 6'b000000;
	Signal <= 4'b0000;
	TV <= 2'b00;
	ST <= 1'b0;
	SE <= 1'b0;
	reset <= 1'b0;
end

always @ (posedge clk) begin
	if (TR) begin
		TV <= 2'b10;
		count <= 6'b000001;
	end
	
	else if (VL) begin
		TV <= 2'b01;
		count <= 6'b000001;
	end

	else if (END | reset) begin
		TV <= 2'b00;
		count <= 6'b000000;
	end

	else begin
		count <= count + 6'b000001;
	end
end

always @ (negedge clk) begin
	casex ({TV,count})
	8'b00_xxxxxx: begin			//None
		reset <= 1'b1;
		Signal <= 4'b0000;
	end
	// Training
	8'b10_000000: reset <= 1'b0;
	8'b10_000001: begin			//Forward: Hidden Start
		Signal <= 4'b1000;
		reset <= 1'b0;
	end
	8'b10_000101: begin			//Forward: Output Start
		Signal <= 4'b0100;
		reset <= 1'b0;
	end
	8'b10_001001: begin			//Backward: Output Start
		Signal <= 4'b0101;
		reset <= 1'b0;
	end
	8'b10_001010: begin			//Backward: Output
		Signal <= 4'b0001;
		reset <= 1'b0;
	end
	8'b10_001011: begin			//Backward: Output + Hidden Start
		Signal <= 4'b1011;
		reset <= 1'b0;
	end
	8'b10_001100: begin			//Backward: Output + Hidden
		Signal <= 4'b0011;
		reset <= 1'b0;
	end
	8'b10_010011: begin			//Backward: Hidden Continue
		Signal <= 4'b0010;
		reset <= 1'b0;
	end
	8'b10_010101: begin			//Training Complete
		Signal <= 4'b0000;
		ST <= 1'b1;
		reset <= 1'b0;
	end
	8'b10_010110: begin			//Training Complete
		ST <= 1'b0;
		reset <= 1'b1;
	end
	// Validation
	8'b01_000000: reset <= 1'b0;
	8'b01_000001: begin			//Forward: Hidden Start
		Signal <= 4'b1000;
		reset <= 1'b0;
	end
	8'b01_000101: begin			//Forward: Output Start + Hidden End
		Signal <= 4'b0100;
		reset <= 1'b0;
	end
	8'b01_001001: begin			//Validation Complete
		Signal <= 4'b0000;
		SE <= 1'b1;
		reset <= 1'b0;
	end
	8'b01_001010: begin			//Validation Complete
		SE <= 1'b0;
		reset <= 1'b1;
	end
	endcase
end

endmodule // ArchCTRL