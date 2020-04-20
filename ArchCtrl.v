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

always @ (posedge clk) begin
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

always @ (posedge clk) begin
	casex ({TV,count})
	8'b00_xxxxxx: begin
		count <= 6'b000000;
		Signal <= 4'b0000;
	end
	8'bxx_000100: begin
		Signal <= 4'b0100;
	end
	8'b10_010110: begin
		Signal <= 4'b0001;
	end
	8'b10_100110: begin
		Signal <= 4'b0011;
	end
	8'b10_101111: begin
		Signal <= 4'b0001;
	end
	8'b10_110111: begin
		Signal <= 4'b0000;
		count <= 6'b000000;
		TV <= 2'b00;
	end
	8'b01_010110: begin
		Signal <= 4'b0000;
		count <= 6'b000000;
		TV <= 2'b00;
	end
	endcase
end

endmodule // ArchCTRL