`timescale 1ns / 1ps

// 4bit + 4bit => carry, 4bit sum
module add4_sub4(
    input [3:0] a,
    input [3:0] b,
    input select,
    output carry_out,
    output [3:0] sum
);

    assign {carry_out, sum} = select ? a + b : a + ~b + 4'b1;

endmodule
