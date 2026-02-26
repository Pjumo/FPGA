`timescale 1ns / 1ps

module tick_gen(
    input clk,
    input reset,
    output reg tick_led
);
    parameter INPUT_FREQUENCY = 100_000_000;
    parameter TICK_Hz = 1000;
    parameter TICK_COUNT = INPUT_FREQUENCY / TICK_Hz;

    reg [$clog2(TICK_COUNT)-1:0] r_tick_counter = 0;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            tick_led <= 0;
            r_tick_counter <= 0;
        end else begin
            if(r_tick_counter == TICK_COUNT - 1) begin
                r_tick_counter <= 0;
                tick_led <= 1'b1;
            end else begin
                r_tick_counter <= r_tick_counter + 1;
                tick_led <= 1'b0;
            end
        end
    end

endmodule
