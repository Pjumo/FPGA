`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input [2:0] btn,    // btnL, btnC, btnR
    input [7:0] sw,
    output [7:0] seg,
    output [3:0] an,
    output [15:0] led
);
    wire [2:0] w_debounced_btn;
    wire [13:0] seg_data;
    wire w_tick;

    tick_gen u_tick_gen(
        .clk        (clk),
        .reset      (reset),
        .tick_led   (w_tick)
    );

    btn_debouncer u_btn_debouncer(
        .clk            (clk),
        .reset          (reset),
        .btn            (btn),
        .debounced_btn  (w_debounced_btn)
    );

    control_tower u_control_tower(
        .clk        (clk),
        .reset      (reset),
        .btn        (w_debounced_btn),
        .sw         (sw),
        .led        (led),
        .seg_data   (seg_data)
    );

    fnd_controller u_fnd_controller(
        .clk    (clk),
        .reset  (reset),
        .tick   (w_tick),
        .in_data(seg_data),
        .an     (an),
        .seg    (seg)
    );

endmodule
