`timescale 1ns / 1ps

module tb_fadder_4bit();
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire [3:0] sum;
    wire cout;
    integer i;

    fadder_4bit fadder_4bit_test(
        .a          (a),
        .b          (b),
        .carry_in   (cin),
        .sum        (sum),
        .carry_out  (cout)
    );

    initial begin
        #00 a=0; b=0; cin=0;
        #10 a=0; b=2;
        #10 a=7; b=9;
        #10 a=9; b=9;
        #10 a=7; b=7;
        for(i=0;i<20;i=i+1) begin
            #10 a=i; b=i+1;
        end
        #10 $finish;
    end
endmodule
