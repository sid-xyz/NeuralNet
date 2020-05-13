`timescale 1ns / 1ps

module Multiplier #(parameter BITS = 32) (
    input   [BITS-1:0]  A,
    input   [BITS-1:0]  B,
    output  [BITS-1:0]  AB
);

wire [(2*BITS)-1:0] mult;
wire [BITS-1:0] Ax, Bx, result;

// wire flow, check;
// wire [BITS-1:0] result;

localparam MSB = BITS - 1;

assign Ax = (A[BITS-1]) ? (~A)+1 : A;
assign Bx = (B[BITS-1]) ? (~B)+1 : B;
assign mult = Ax * Bx;

assign result = mult[(2*BITS)-(BITS/2)-1:(BITS/2)];

//assign AB = A[MSB] ? (B[MSB] ? result : (~result)+1) : (B[MSB] ? (~result)+1 : result);
assign AB = ({A[MSB], B[MSB]} == 2'b10) ? (~result)+1 : (
            ({A[MSB], B[MSB]} == 2'b01) ? (~result)+1 : result);

//assign AB = mult[(2*BITS)-(BITS/2)-1:(BITS/2)];

// assign result = mult[(2*BITS)-(BITS/2)-1:(BITS/2)];

// assign flow = A[MSB] ^ B[MSB];
// assign check = ~(result[MSB] ^ A[MSB]);

// assign AB = (result[MSB] ^ flow) ? (result[MSB] ? 32'h7FFF_FFFF : 32'h8000_0000): result;

endmodule // Multiplier