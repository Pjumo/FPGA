`timescale 1ns / 1ps

module top #(
    parameter TICK_Hz = 1000
)(
    input reset,
    input clk,
    input btn,
    output [15:0] led
);
    wire w_tick;
    wire w_debounced_btn;

    tick_gen #(.TICK_Hz(TICK_Hz)) u_tick_gen(
        .clk    (clk),
        .tick   (w_tick)
    );

    btn_debouncer u_btn_debouncer(
        .tick           (w_tick),
        .btn            (btn),
        .debounced_btn  (w_debounced_btn)
    );

    control_tower u_control_tower(
        .tick   (w_tick),
        .reset  (reset),
        .btn    (btn),
        .led    (led)
    );
endmodule
