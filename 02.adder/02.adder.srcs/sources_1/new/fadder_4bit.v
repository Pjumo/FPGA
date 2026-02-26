`timescale 1ns / 1ps

module fadder_4bit(
    input [3:0] a,
    input [3:0] b,
    input carry_in,
    output [3:0] sum,
    output carry_out
);

    wire carry0, carry1, carry2;

    fadder fa0(
        .a          (a[0]),
        .b          (b[0]),
        .carry_in   (carry_in),
        .sum        (sum[0]),
        .carry_out  (carry0)
    );

    fadder fa1(
        .a          (a[1]),
        .b          (b[1]),
        .carry_in   (carry0),
        .sum        (sum[1]),
        .carry_out  (carry1)
    );

    fadder fa2(
        .a          (a[2]),
        .b          (b[2]),
        .carry_in   (carry1),
        .sum        (sum[2]),
        .carry_out  (carry2)
    );

    fadder fa3(
        .a          (a[3]),
        .b          (b[3]),
        .carry_in   (carry2),
        .sum        (sum[3]),
        .carry_out  (carry_out)
    );

endmodule
