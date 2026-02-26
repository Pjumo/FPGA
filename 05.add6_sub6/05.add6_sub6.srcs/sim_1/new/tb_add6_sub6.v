`timescale 1ns / 1ps

module tb_add6_sub6();

    reg [5:0] a;
    reg [5:0] b;
    reg sel;
    wire [5:0] sum;
    wire cout;

    add6_sub6 add_sub_test(
        .a      (a),
        .b      (b),
        .sel    (sel),
        .sum    (sum),
        .cout   (cout)
    );

    initial begin
        sel = 0; a = 6'b101010; b = 6'b010101;  // 뺄셈
        #10 a = 6'b111111; b = 6'b101111;
        #10 a = 6'b000011; b = 6'b010000;
        #10 sel = 1; a = 6'b101010; b = 6'b010101;  // 덧셈
        #10 a = 6'b111111; b = 6'b101111;
        #10 a = 6'b000011; b = 6'b010000;
        #10 $finish;
    end

endmodule
