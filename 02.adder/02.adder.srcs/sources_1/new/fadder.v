`timescale 1ns / 1ps

module fadder(
    input carry_in,
    input a,
    input b,
    output sum, 
    output carry_out
);
    wire sum1, carry1, carry2;

    hadder ha1(
        .a(a),
        .b(b),
        .sum(sum1),
        .carry_out(carry1)
    );

    hadder ha2(
        .a(carry_in),
        .b(sum1),
        .sum(sum),
        .carry_out(carry2)
    );

    assign carry_out = carry1 | carry2;

endmodule
