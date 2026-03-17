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
    wire [13:0] w_seg_data;
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

    control_tower u_control_tower(
        .clk        (clk),
        .reset      (reset),
        .btn        (w_debounced_btn),
        .sw         (sw),
        .rx_done    (w_rx_done),
        .rx_data    (w_rx_data),
        .led        (led),
        .seg_data   (w_seg_data)
    );

    circular_queue_v2 u_circular_queue_v2(
        .clk        (clk),
        .reset      (reset),
        .rx_done    (w_rx_done),
        .rx_data    (w_rx_data),
        .led        (led)
    );

    fnd_controller u_fnd_controller(
        .clk    (clk),
        .reset  (reset),
        .in_data(w_seg_data),
        .an     (an),
        .seg    (seg)
    );

    assign uartRx = RsRx;
    assign uartTx = RsTx;
endmodule
