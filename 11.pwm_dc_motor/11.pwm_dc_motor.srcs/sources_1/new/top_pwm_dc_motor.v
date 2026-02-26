`timescale 1ns / 1ps

module top_pwm_dc_motor(
    input clk,
    input reset,
    input [1:0] motor_direction,
    input increase_duty_btn,
    input decrease_duty_btn,
    output PWM_LED_OUT,
    output PWM_OUT,
    output [1:0] in1_in2,
    output [7:0] seg,
    output [3:0] an
);
    wire w_clean_inc_btn;
    wire w_clean_dec_btn;
    wire [3:0] w_duty_cycle;

    debouncer u_increase_duty_btn(
        .clk        (clk),
        .reset      (reset),
        .noisy_btn  (increase_duty_btn),
        .clean_btn  (w_clean_inc_btn)
    );

    debouncer u_decrease_duty_btn(
        .clk        (clk),
        .reset      (reset),
        .noisy_btn  (decrease_duty_btn),
        .clean_btn  (w_clean_dec_btn)
    );

    pwm_duty_control u_pwm_duty_control(
        .clk        (clk),
        .reset      (reset),
        .duty_inc   (w_clean_inc_btn),
        .duty_dec   (w_clean_dec_btn),
        .DUTY_CYCLE (w_duty_cycle),
        .PWM_OUT    (PWM_OUT),
        .PWM_LED_OUT(PWM_LED_OUT)
    );

    fnd_controller u_fnd_controller(
        .clk        (clk),
        .reset      (reset),
        .in_data    (w_duty_cycle),
        .isFront    (motor_direction),
        .an         (an),
        .seg        (seg)
    );

    assign in1_in2 = motor_direction;
endmodule
