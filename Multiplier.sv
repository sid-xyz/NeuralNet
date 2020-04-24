`timescale 1ns / 1ps

module Multiplier #(parameter BITS = 16) (
    input   [BITS-1:0]  A,
    input   [BITS-1:0]  B,
    output  [BITS-1:0]  AB
);

wire [(2*BITS)-1:0] mult;
wire [BITS-1:0] Ax, Bx;

assign Bx = (B[BITS-1]) ? (~B)+1 : B;
assign Ax = (B[BITS-1]) ? (~A)+1 : A;
assign mult = Ax * Bx;

assign AB = mult[(2*BITS)-(BITS/2)-1:(BITS/2)];

endmodule // Multiplier