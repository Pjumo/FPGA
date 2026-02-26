`timescale 1ns / 1ps

module add6_sub6(
    input [5:0] a,
    input [5:0] b,
    input sel,
    output [5:0] sum,
    output cout
);

    wire cout_add, cout_sub;
    wire [5:0] sum_add, sum_sub;

    adder6 adder(
        .a      (a),
        .b      (b),
        .sum    (sum_add),
        .cout   (cout_add)
    );

    subtractor6 subtractor(
        .a      (a),
        .b      (b),
        .sum    (sum_sub),
        .cout   (cout_sub)
    );

    assign {cout, sum} = sel ? {cout_add, sum_add} : {cout_sub, sum_sub};

endmodule
