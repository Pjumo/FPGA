`timescale 1ns / 1ps

module rotary(
    input clk,
    input reset,
    input clean_s1,
    input clean_s2,
    input clean_key,
    output [15:0] led
);
    reg [1:0] r_direction = 2'b00;  // 시계 방향 : 01, 반시계 방향 : 10
    reg [1:0] r_prev_state = 2'b00;
    reg [1:0] r_current_state = 2'b00;
    reg [7:0] r_counter = 8'h00;

    // s1, s2
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_direction = 2'b00;
            r_prev_state = 2'b00;
            r_current_state = 2'b00;
            r_counter = 8'h00;
        end else begin  // 동시성을 고려했을 때, 다음 clk에서 r_prev, r_current 적용됨
            r_prev_state <= r_current_state;
            r_current_state <= {clean_s1, clean_s2};
            case({r_prev_state, r_current_state})
                4'b0010, 4'b1011, 4'b1101, 4'b0100: begin
                    if(r_counter < 8'hFF)   // overflow
                        r_counter <= r_counter + 1;
                    
                    r_direction <= 2'b01;
                end
                4'b0001, 4'b0111, 4'b1110, 4'b1000: begin
                    if(r_counter > 8'h00)
                        r_counter <= r_counter - 1;
                    
                    r_direction <= 2'b10;
                end
            endcase
        end
    end

    reg r_led_toggle = 1'b0;
    reg r_prev_key = 1'b0;
    // key
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_led_toggle = 1'b0;
            r_prev_key = 1'b0;
        end else begin
            r_prev_key <= clean_key;
            if(!r_prev_key && clean_key)
                r_led_toggle <= ~r_led_toggle;
        end
    end

    assign led[15:14] = r_direction;
    assign led[7:0] = r_counter;
    assign led[13] = r_led_toggle;
endmodule
