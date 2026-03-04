`timescale 1ns / 1ps

module top_buzzer(
    input clk,
    input reset, //sw[15]
    input btnU, // 도
    input btnL, // 레
    input btnC, // 미
    input btnR, // 솔
    input btnD, // 라
    output [1:0] led,
    output buzzer
    );

    wire w_btnU, w_btnL, w_btnC, w_btnR, w_btnD;

    btn_debouncer u_btn_debouncer (
        .clk(clk),
        .btn({btnU, btnL, btnC, btnR, btnD}),
        .debounced_btn({w_btnU, w_btnL, w_btnC, w_btnR, w_btnD})
    );

    play_melody u_play_melody(
        .clk(clk),
        .reset(reset),
        .btnU(w_btnU), 
        .btnL(w_btnL), 
        .btnC(w_btnC), 
        .btnR(w_btnR),
        .btnD(w_btnD), 
        .buzzer(buzzer)
    );

endmodule
