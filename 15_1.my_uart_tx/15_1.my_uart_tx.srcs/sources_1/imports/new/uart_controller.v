`timescale 1ns / 1ps

module uart_controller #(
    parameter BPS = 9600
) (
    input clk,
    input reset,
    input btn,
    input [7:0] send_data,
    input rx,
    output tx
);
    wire w_start_trigger;
    wire w_tx_start, w_tx_busy, w_tx_done;
    wire [7:0] w_tx_data;

    start_gen u_start_gen(
        .clk            (clk),
        .reset          (reset),
        .btn            (btn),
        .start_trigger  (w_start_trigger)
    );

    data_sender u_data_sender(
        .clk            (clk),
        .reset          (reset),
        .start_trigger  (w_start_trigger),
        .send_data      (send_data),
        .tx_busy        (w_tx_busy),
        .tx_done        (w_tx_done),
        .tx_data        (w_tx_data),
        .tx_start       (w_tx_start)
    );

    uart_tx #(
        .BPS(BPS)
    ) u_uart_tx(
        .clk        (clk),
        .reset      (reset),
        .tx_data    (w_tx_data),
        .tx_start   (w_tx_start),
        .tx         (tx),
        .tx_done    (w_tx_done),
        .tx_busy    (w_tx_busy)
    );

endmodule
