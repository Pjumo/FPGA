`timescale 1ns / 1ps

module top #(
    parameter BPS = 9600,
    parameter DEBOUNCE_LIMIT = 999_999
) (
    input clk,
    input reset,
    input [7:0] sw,
    input btnL,
    input RsRx,
    output RsTx
);
    wire w_clean_btn;

    debouncer #(
        .DEBOUNCE_LIMIT(DEBOUNCE_LIMIT)
    ) u_debouncer(
        .clk        (clk),
        .reset      (reset),
        .noisy_btn  (btnL),
        .clean_btn  (w_clean_btn)
    );

    uart_controller #(
        .BPS(BPS)
    ) u_uart_controller(
        .clk        (clk),
        .reset      (reset),
        .btn        (w_clean_btn),
        .send_data  (sw),
        .rx         (RsRx),
        .tx         (RsTx)
    );


endmodule
