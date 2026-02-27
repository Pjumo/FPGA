`timescale 1ns / 1ps

module make_buzzer(
    input clk,
    input reset,
    input btnL,
    input btnR,
    output buzzer
);
    wire w_btnL, w_btnR;

    btn_debouncer u_btn_debouncer(
        .clk            (clk),
        .btn            ({btnL, btnR}),
        .debounced_btn  ({w_btnL, w_btnR})
    );

    play_beep u_play_beep(
        .clk    (clk),
        .reset  (reset),
        .btnL   (w_btnL),
        .btnR   (w_btnR),
        .buzzer (buzzer)
    );
endmodule
