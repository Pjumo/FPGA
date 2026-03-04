`timescale 1ns / 1ps

module top_rotary #(
    parameter DEBOUNCE_LIMIT_S = 200_000, 
    DEBOUNCE_LIMIT_KEY = 999_999
    )(
    input clk,
    input reset,
    input s1,
    input s2,
    input key,
    output [15:0] led
);
    wire w_clean_s1, w_clean_s2, w_clean_key;

    debouncer #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT_S)) u_s1_debouncer(   // rotary : 2ms (200_000)
        .clk        (clk),
        .noisy_btn  (s1),
        .clean_btn  (w_clean_s1)
    );

    debouncer #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT_S)) u_s2_debouncer(
        .clk        (clk),
        .noisy_btn  (s2),
        .clean_btn  (w_clean_s2)
    );

    debouncer #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT_KEY)) u_key_debouncer(
        .clk        (clk),
        .noisy_btn  (key),
        .clean_btn  (w_clean_key)
    );

    rotary u_rotary(
        .clk        (clk),
        .reset      (reset),
        .clean_s1   (w_clean_s1),
        .clean_s2   (w_clean_s2),
        .clean_key  (w_clean_key),
        .led        (led)
    );
endmodule
