`timescale 1ns / 1ps

module tb_encoder();
    reg [3:0] a;
    wire [1:0] out;

    encoder encoder_test(
        .a      (a),
        .out    (out)
    );

    initial begin
        a = 4'b0001;
        #10 a = 4'b0010;
        #10 a = 4'b0100;
        #10 a = 4'b1000;
        #10 $finish;
    end

endmodule
