`timescale 1ns / 1ps

module control_tower(
    input tick,
    input reset,
    input btn,
    output reg [15:0] led
);
    reg r_prev_btn = 0;
    reg [1:0] eventNum = 0;
    reg [5:0] tick_50ms_counter = 0;
    reg [3:0] led_counter = 0;

    always @(posedge tick, posedge reset) begin
        if(reset) begin
            eventNum <= 0;
            tick_50ms_counter <= 0;
            led_counter <= 0;
        end else begin
            if(btn && !r_prev_btn) begin
                eventNum <= eventNum + 1;
                led_counter <= 0;
                tick_50ms_counter <= 0;
            end
            
            if(tick_50ms_counter == 49) begin
                tick_50ms_counter <= 0;
                led_counter <= led_counter + 1;
            end else begin
                tick_50ms_counter <= tick_50ms_counter + 1;
            end
            r_prev_btn <= btn;
        end
    end

    always @(posedge tick, posedge reset) begin
        if(reset) begin
            led <= 0;
        end else begin
            case(eventNum)
                2'b00: begin
                    led <= (16'b1000_0000_0000_0000 >> led_counter);
                end
                2'b01: begin
                    led <= (16'b0000_0000_0000_0001 << led_counter);
                end
                2'b10: begin
                    led[15:8] <= (8'b1111_1111 >> (7-led_counter % 8));
                    led[7:0] <= (8'b1111_1111 << (7-led_counter % 8));
                end
                2'b11: begin
                    led[15:8] <= (8'b1111_1111 >> led_counter % 8);
                    led[7:0] <= (8'b1111_1111 << led_counter % 8);
                end
                default:
                    led <= 16'hFFFF;
            endcase
        end
    end

endmodule
