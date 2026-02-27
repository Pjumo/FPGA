`timescale 1ns / 1ps

module play_beep(
    input clk,
    input reset,
    input btnL,
    input btnR,
    output buzzer
);
    localparam L1 = 50_000;
    localparam L2 = 25_000;
    localparam L3 = 16_667;
    localparam L4 = 12_500;

    localparam R1 = 191_571;
    localparam R2 = 151_976;
    localparam R3 = 127_551;
    localparam R4 = 90_253;

    reg r_prev_btnL, r_prev_btnR;
    reg [21:0] r_clk_cnt;
    reg [$clog2(7_000_000)-1:0] cnt_70ms;

    reg r_buzzer_frequency;
    reg [1:0] btn_click = 0;    // 00 -> none, 01 -> btnL click, 10 -> btnR click
    reg [1:0] r_btn_counter = 0;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_clk_cnt <= 0;
            r_buzzer_frequency <= 0;
            btn_click <= 2'b00;
            cnt_70ms <= 0;
        end else begin
            if(btnL && !r_prev_btnL) begin
                r_clk_cnt <= 0;
                btn_click <= 2'b01;
                r_buzzer_frequency <= 0;
                cnt_70ms <= 0;
            end else if (btnR && !r_prev_btnR) begin
                r_clk_cnt <= 0;
                btn_click <= 2'b10;
                r_buzzer_frequency <= 0;
                cnt_70ms <= 0;
            end

            if(btn_click == 2'b01) begin
                case(r_btn_counter)
                2'b00: begin
                    if(r_clk_cnt >= L1) begin
                        r_clk_cnt <= 0;
                        r_buzzer_frequency <= ~r_buzzer_frequency;
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end
                2'b01: begin
                    if(r_clk_cnt >= L2) begin
                        r_clk_cnt <= 0;
                        r_buzzer_frequency <= ~r_buzzer_frequency;
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end
                2'b10: begin
                    if(r_clk_cnt >= L3) begin
                        r_clk_cnt <= 0;
                        r_buzzer_frequency <= ~r_buzzer_frequency;
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end
                2'b11: begin
                    if(r_clk_cnt >= L4) begin
                        r_clk_cnt <= 0;
                        r_buzzer_frequency <= ~r_buzzer_frequency;
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end
                endcase
            end else if(btn_click == 2'b10) begin
                case(r_btn_counter)
                2'b00: begin
                    if(r_clk_cnt >= R1) begin
                        r_clk_cnt <= 0;
                        r_buzzer_frequency <= ~r_buzzer_frequency;
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end
                2'b01: begin
                    if(r_clk_cnt >= R2) begin
                        r_clk_cnt <= 0;
                        r_buzzer_frequency <= ~r_buzzer_frequency;
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end
                2'b10: begin
                    if(r_clk_cnt >= R3) begin
                        r_clk_cnt <= 0;
                        r_buzzer_frequency <= ~r_buzzer_frequency;
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end
                2'b11: begin
                    if(r_clk_cnt >= R4) begin
                        r_clk_cnt <= 0;
                        r_buzzer_frequency <= ~r_buzzer_frequency;
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end
                endcase
            end else begin
                r_buzzer_frequency <= 0;
            end

            if(btn_click == 2'b01 || btn_click == 2'b10) begin
                if(cnt_70ms >= 7_000_000) begin
                    cnt_70ms <= 0;
                    if(r_btn_counter == 2'b11) btn_click <= 2'b00;
                    r_btn_counter <= r_btn_counter + 1;
                end else begin
                    cnt_70ms <= cnt_70ms + 1;
                end
            end
        end
        r_prev_btnL = btnL;
        r_prev_btnR = btnR;
    end

    assign buzzer = r_buzzer_frequency;
    
endmodule
