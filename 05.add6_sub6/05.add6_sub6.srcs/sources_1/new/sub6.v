`timescale 1ns / 1ps

module sub6(
    input [5:0] a,
    input [5:0] b,
    output [5:0] sum,
    output cout
);
    assign {cout, sum} = a + ~b + 6'b1;
endmodule
