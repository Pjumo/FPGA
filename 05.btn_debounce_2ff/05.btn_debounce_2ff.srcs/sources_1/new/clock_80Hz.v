`timescale 1ns / 1ps

module clock_80Hz(
    input i_clk,
    input i_reset,
    output reg o_clk
);
    // reg[23:0] r_counter = 0;    // 1,250,000 * 10ns = 12.5ms
    reg [$clog2(1250000)-1:0] r_counter = 0;    // 자동으로 size 계산

    // 10ns 의 clk가 오거나 i_reset 버튼을 누르면 항상 수행
    always @(posedge i_clk, posedge i_reset) begin
        if(i_reset) begin   // 비동기 reset 0 -> 1
            r_counter <= 0;
            o_clk <= 0;
        end else begin
            if(r_counter == (1_250_000/2)-1) begin  // 80Hz 1주기 12.5ms
                r_counter <= 0;
                o_clk <= ~o_clk;
            end else begin
                r_counter <= r_counter +1;
            end
        end
    end
endmodule
