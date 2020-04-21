module ArchCTRL(
	input	clk,
	input	TR,
	input	VL,
	output	FPH,
	output	FPO,
	output	BPH,
	output	BPO
);

reg [5:0] count;
reg [3:0] Signal;
reg [1:0] TV;

assign {FPH, FPO, BPH, BPO} = Signal;

initial begin
	count <= 6'b000000;
	Signal <= 4'b0000;
	TV <= 2'b00;
end

always @ (negedge clk) begin
	if (TR) begin
		TV <= 2'b10;
		count <= 6'b000000;
		Signal <= 4'b1000;
	end
	
	else if (VL) begin
		TV <= 2'b01;
		count <= 6'b000000;
		Signal <= 4'b1000;
	end

	else begin
		count <= count + 6'b000001;
	end
end

always @ (negedge clk) begin
	casex ({TV,count})
	8'b00_xxxxxx: begin			//None
		count <= 6'b000000;
		Signal <= 4'b0000;
	end
	// Training
	8'b10_000000: begin			//Forward: Hidden Start
		Signal <= 4'b1000;
	end
	8'b10_000100: begin			//Forward: Output Start
		Signal <= 4'b0100;
	end
	8'b10_010101: begin			//Backward: Output Start
		Signal <= 4'b0101;
	end
	8'b10_010110: begin			//Backward: Output
		Signal <= 4'b0001;
	end
	8'b10_100101: begin			//Backward: Output + Hidden Start
		Signal <= 4'b1011;
	end
	8'b10_100110: begin			//Backward: Output + Hidden End
		Signal <= 4'b0011;
	end
	8'b10_101111: begin			//Backward: Output Continue
		Signal <= 4'b0001;
	end
	8'b10_110111: begin			//Training Complete
		Signal <= 4'b0000;
		count <= 6'b000000;
		TV <= 2'b00;
	end
	// Validation
	8'b01_000000: begin			//Forward: Hidden Start
		Signal <= 4'b1000;
	end
	8'b01_000100: begin			//Forward: Output Start + Hidden End
		Signal <= 4'b0100;
	end
	8'b01_010101: begin			//Validation Complete
		Signal <= 4'b0000;
		count <= 6'b000000;
		TV <= 2'b00;
	end
	endcase
end

endmodule // ArchCTRL