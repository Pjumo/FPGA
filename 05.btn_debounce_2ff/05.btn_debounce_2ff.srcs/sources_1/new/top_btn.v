`timescale 1ns / 1ps

module top_btn(
    input clk,
    input reset,
    input btnC,
    output [1:0] led
);
    wire w_clean_btn;

    button_debounce u_button_debounce(
        .i_btn      (btnC),
        .i_clk      (clk),
        .i_reset    (reset),
        .o_clean_btn(w_clean_btn)
    );

    led_toggle u_led_toggle(
        .btn_debounce   (w_clean_btn),
        .led            (led)
    );

endmodule
