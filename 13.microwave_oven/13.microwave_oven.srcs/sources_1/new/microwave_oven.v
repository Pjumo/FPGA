`timescale 1ns / 1ps

module microwave_oven(
    input clk,
    input reset,
    input btnU,
    input btnL,
    input btnC,
    input btnR,
    input btnD,
    output buzzer,
    output PWM_OUT,
    output led,
    output [7:0] seg,
    output [3:0] an
);
    wire w_btn_door, w_btn_30s, w_btn_10s, w_btn_power, w_btn_cancel;
    wire w_time_out;
    wire [13:0] w_in_data;

    btn_debouncer u_btn_debouncer(
        .clk            (clk),
        .btn            ({btnU, btnL, btnC, btnR, btnD}),
        .debounced_btn  ({w_btn_power, w_btn_10s, w_btn_door, w_btn_30s, w_btn_cancel})
    );

    microwave_time u_microwave_time(
        .clk        (clk),
        .reset      (reset),
        .btn_10s    (w_btn_10s),
        .btn_30s    (w_btn_30s),
        .btn_cancel (w_btn_cancel),
        .in_data    (w_in_data),
        .time_out   (w_time_out)
    );

    fnd_controller u_fnd_controller(
        .clk        (clk),
        .reset      (reset),
        .time_out   (w_time_out),
        .in_data    (w_in_data),
        .seg        (seg),
        .an         (an)
    );
endmodule
