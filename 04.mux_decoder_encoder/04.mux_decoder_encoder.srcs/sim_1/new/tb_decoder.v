`timescale 1ns / 1ps

module tb_decoder();
    
    reg [1:0] a;
    wire [3:0] out;

    decoder decoder_test(
        .a      (a),
        .out    (out)
    );

    initial begin
        a = 2'b00;
        #10 a = 2'b01;
        #10 a = 2'b10;
        #10 a = 2'b11;
        #10 $finish;
    end
endmodule
