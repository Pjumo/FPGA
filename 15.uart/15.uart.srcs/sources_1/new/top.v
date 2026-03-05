`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input [2:0] btn,
    input [7:0] sw,
    input RsRx,
    output RsTx,
    output [7:0] seg,
    output [3:0] an,
    output [15:0] led,
    output uartTx,
    output uartRx
);
    wire [2:0] w_debounced_btn;
    wire [7:0] w_rx_data;
    wire w_rx_done;

    btn_debouncer u_btn_debouncer(
        .clk            (clk),
        .reset          (reset),
        .btn            (btn),
        .debounced_btn  (w_debounced_btn)
    );

    uart_controller u_uart_controller(
        .clk        (clk),
        .reset      (reset),
        .send_data  (8'h30),    // '0' : temp
        .rx         (RsRx),
        .tx         (RsTx),
        .rx_data    (w_rx_data),
        .rx_done    (w_rx_done)
    );

    assign uartRx = RsRx;
    assign uartTx = RsTx;
endmodule
