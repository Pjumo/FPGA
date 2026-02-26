`timescale 1ns / 1ps

module delay_time(
    input i_clk,
    input i_reset,
    input i_btn,
    output reg delay_out
);
    integer cnt = 0;
    always @(posedge i_clk, posedge i_reset) begin
        if(i_reset) begin
            cnt <= 0;
            delay_out = 0;
        end else begin
            cnt <= cnt + 1;
            if(cnt == 1_000_000) begin
                delay_out <= i_btn;
                cnt <= 0;
            end
        end
    end
endmodule
