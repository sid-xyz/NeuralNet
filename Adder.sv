`timescale 1ns / 1ps

module Adder #(parameter BITS = 32) (
	input	[BITS-1:0]	A,
	input	[BITS-1:0]	B,
	output	[BITS-1:0]	C
);

// wire flow, check;
// wire [BITS-1:0] result;

// localparam MSB = BITS - 1;

// assign flow = ~(A[MSB] ^ B[MSB]);
// assign result = A + B;
// assign check = (result[MSB] ^ A[MSB]);

// assign C = flow ? (check ? (A[MSB] ? 32'h8000_0000 : 32'h7FFF_FFFF): result) : result;

assign C = A + B;

endmodule // Adder