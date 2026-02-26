`timescale 1ns / 1ps

module button_debounce(
    input i_btn,
    input i_clk,
    input i_reset,
    output reg o_clean_btn
);
    wire o_delay_out;

    delay_time u_delay_time(
        .i_clk       (i_clk),
        .i_reset     (i_reset),
        .i_btn       (i_btn),
        .delay_out   (o_delay_out)
    );

    always @(posedge i_clk, posedge i_reset) begin
        if(i_reset) begin
            o_clean_btn <= 0;
        end else begin
            o_clean_btn <= o_delay_out;
        end
    end

endmodule
