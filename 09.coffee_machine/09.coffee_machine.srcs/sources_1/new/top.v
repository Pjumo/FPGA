`timescale 1ns / 1ps

module top #(parameter TICK_Hz = 1000)(
    input clk,
    input reset,
    input [2:0] btn,
    output [7:0] seg,
    output [3:0] an
);
    wire [2:0] w_debounced_btn;
    wire [15:0] w_coin_val;
    wire w_seg_en, w_coffee_make, w_coin_return;
    wire tick;
    wire coffee_out;
    wire [13:0] in_data;
    reg [2:0] r_prev_btn = 0;
    reg [2:0] real_btn_signal = 0;

    integer i;

    tick_gen #(.TICK_Hz(TICK_Hz)) u_tick_gen (
        .clk    (clk),
        .tick   (tick)
    );

    btn_debouncer u_btn_debouncer(
        .tick           (tick),
        .btn            (btn),
        .debounced_btn  (w_debounced_btn)
    );

    coffee_machine u_coffee_machine(
        .tick           (tick),
        .reset          (reset),
        .coin           (real_btn_signal[0]),
        .coffee_btn     (real_btn_signal[2]),
        .coin_return_btn(real_btn_signal[1]),
        .coffee_out     (coffee_out),
        .coin_val       (w_coin_val),
        .seg_en         (w_seg_en),
        .coffee_make    (w_coffee_make),
        .coin_return    (w_coin_return)
    );

    coffee_machine_logic u_coffee_machine_logic(
        .tick           (tick),
        .reset          (reset),
        .coffee_out     (coffee_out),
        .coin_val       (w_coin_val),
        .seg_en         (w_seg_en),
        .coffee_make    (w_coffee_make),
        .coin_return    (w_coin_return),
        .in_data        (in_data)
    );

    fnd_controller u_fnd_controller(
        .tick   (tick),
        .in_data(in_data),
        .an     (an),
        .seg    (seg)
    );

    always @(posedge tick, posedge reset) begin
        if(reset) begin
            r_prev_btn <= 0;
        end else begin
            for(i=2;i>=0;i=i-1) begin
                if(w_debounced_btn[i] && !r_prev_btn[i]) begin
                    real_btn_signal[i] = 1;
                end else if(!w_debounced_btn[i] && r_prev_btn[i]) begin
                    real_btn_signal[i] = 0;
                end
            end

            r_prev_btn <= w_debounced_btn;
        end
    end

endmodule
