`timescale 1ns / 1ps

module tb_buzzer();

    reg clk;
    reg reset;
    reg btnL;
    reg btnR;
    wire buzzer;

    make_buzzer u_make_buzzer(
        .clk(clk),
        .reset(reset),
        .btnL(btnL),
        .btnR(btnR),
        .buzzer(buzzer)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1;
        #100;
        reset = 0;
        #100;
        btnL = 1;
        #12_000_000;
        btnL = 0;
        #300_000_000;
        
        btnR = 1;
        #12_000_000;
        btnR = 0;
        #300_000_000;
    end
endmodule
