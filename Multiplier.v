`timescale 1ns / 1ps

module Multiplier(
    input   [15:0]  A,
    input   [15:0]  B,
    output  [15:0]  AB
);

wire [31:0] mult;
wire [15:0] Ax, Bx;

assign Bx = (B[15]) ? (~B)+1 : B;
assign Ax = (B[15]) ? (~A)+1 : A;
assign mult = Ax * Bx;

assign AB = mult[23:8];

endmodule // Multiplier