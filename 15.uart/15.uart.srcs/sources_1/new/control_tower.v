`timescale 1ns / 1ps

module control_tower(
    input clk,
    input reset,
    input [2:0] btn,
    input [7:0] sw,
    input rx_done,
    input [7:0] rx_data,
    output [15:0] led,
    output [13:0] seg_data
);
    parameter UP_COUNTER = 2'b01;
    parameter DOWN_COUNTER = 2'b10;
    parameter SLIDE_SW_READ = 2'b11;

    reg r_prev_btnL = 0;
    reg [1:0] r_mode = 2'b00;
    reg [19:0] r_counter;   // 10ms를 재기 위한 counter 10ns * 1_000_000
    reg [13:0] r_10ms_counter;  // 10ms가 될때마다 1씩 증가 9999까지

    // mode check
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_mode <= 0;
            r_prev_btnL <= 0;
        end else begin
            if(btn[0] && !r_prev_btnL)
                r_mode = (r_mode == SLIDE_SW_READ) ? UP_COUNTER : r_mode + 1;

            if(rx_done && rx_data == 8'h4D)
                r_mode = (r_mode == SLIDE_SW_READ) ? UP_COUNTER : r_mode + 1;
        end
        r_prev_btnL <= btn[0];
    end

    // upcounter
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_counter <= 0;
            r_10ms_counter <= 0;
        end else if(r_mode == UP_COUNTER) begin // 1. add logic
            if(r_counter == 20'd1_000_000-1) begin
                r_counter <= 0;
                if(r_10ms_counter >= 9999) begin
                    r_10ms_counter <= 0;
                end else begin
                    r_10ms_counter <= r_10ms_counter + 1;
                end
                // led[13:0] <= r_10ms_counter;
            end else begin
                r_counter <= r_counter + 1;
            end
        end else if(r_mode == DOWN_COUNTER) begin   // 2. sub logic
            if(r_counter == 20'd1_000_000-1) begin
                r_counter <= 0;
                if(r_10ms_counter == 0) begin
                    r_10ms_counter <= 9999;
                end else begin
                    r_10ms_counter <= r_10ms_counter - 1;
                end
            end else begin
                r_counter <= r_counter + 1;
            end
        end else begin  // 3. SLIDE_SW_READ or IDLE mode
            r_counter <= 0;
            r_10ms_counter <= 0;
        end
    end

    assign led[15:14] = r_mode;

    assign seg_data = (r_mode == UP_COUNTER) ? r_10ms_counter :
                      (r_mode == DOWN_COUNTER) ? r_10ms_counter : sw;
endmodule
