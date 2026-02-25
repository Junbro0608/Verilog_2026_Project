`timescale 1ns / 1ps

module adder #(
    parameter BIT_WIDTH = 32
) (
    input  logic                 mode,
    input  logic [BIT_WIDTH-1:0] a,
    input  logic [BIT_WIDTH-1:0] b,
    output logic [BIT_WIDTH-1:0] s,
    output logic [BIT_WIDTH-1:0] c
);
    // alu
    assign {c, s} = (mode) ? a - b : a + b;

endmodule
