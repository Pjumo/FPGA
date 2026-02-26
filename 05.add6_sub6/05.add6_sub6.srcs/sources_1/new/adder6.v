`timescale 1ns / 1ps

module adder6(
    input [5:0] a,
    input [5:0] b,
    output [5:0] sum,
    output cout
);

    assign {cout, sum} = a + b;

endmodule
