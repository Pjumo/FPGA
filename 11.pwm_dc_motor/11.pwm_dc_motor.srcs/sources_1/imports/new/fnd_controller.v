`timescale 1ns / 1ps

module fnd_controller(
    input clk,
    input reset,
    input [3:0] in_data,
    input [1:0] isFront,
    output [3:0] an,
    output [7:0] seg
);
    wire [1:0] w_sel;
    wire w_on_off;

    fnd_digit_select u_fnd_digit_select(
        .clk    (clk),
        .reset  (reset),
        .sel    (w_sel),
        .on_off (w_on_off)
    );

    fnd_digit_display u_fnd_digit_display(
        .on_off     (w_on_off),
        .digit_sel  (w_sel),
        .in_data    (in_data),
        .isFront    (isFront),
        .an         (an),
        .seg        (seg)
    );

endmodule


module fnd_digit_select(
    input clk,
    input reset,
    output reg [1:0] sel,    // 00 01 10 11 : 1ms마다 바뀜
    output reg on_off
);
    reg [$clog2(100_000_000):0] counter_1s = 0;   // 1s
    reg[$clog2(100_000):0] r_1ms_counter = 0;

    always @(posedge reset, posedge clk) begin
        if(reset) begin
            r_1ms_counter <= 0;
            counter_1s <= 0;
            on_off <= 0;
            sel <= 0;
        end else begin
            if(counter_1s == 100_000_000 -1) begin
                counter_1s <= 0;
                on_off <= ~on_off;
            end else begin
                counter_1s <= counter_1s + 1;
            end

            if(r_1ms_counter == 100_000 - 1) begin
                r_1ms_counter <= 0;
                sel <= sel + 1;
            end else begin
                r_1ms_counter <= r_1ms_counter + 1;
            end
        end
    end
endmodule

module fnd_digit_display(
    input on_off,
    input [1:0] digit_sel,
    input [3:0] in_data,
    input [1:0] isFront,
    output reg [3:0] an,
    output reg [7:0] seg
);
    reg [3:0] bcd_data;

    always @(digit_sel) begin
        case(digit_sel) 
            2'b00: begin
                bcd_data = in_data;
                an = 4'b1110;
            end
            2'b01: begin
                bcd_data = 4'd0;
                an = 4'b1101;
            end
            2'b10: begin
                bcd_data = 4'd0;
                an = 4'b1011;
            end
            2'b11: begin
                if(on_off)
                    bcd_data = (isFront[0] == isFront[1]) ? 4'd15 : (isFront[0]) ? 4'd10 : 4'd11;
                else
                    bcd_data = 4'd15;
                an = 4'b0111;
            end
            default: begin
                bcd_data = 4'd15;
                an = 4'b1111;
            end
        endcase
    end

    always @(bcd_data) begin
        case(bcd_data)
            4'd0: seg = 8'b11000000;
            4'd1: seg = 8'b11111001;
            4'd2: seg = 8'b10100100;
            4'd3: seg = 8'b10110000;
            4'd4: seg = 8'b10011001;
            4'd5: seg = 8'b10010010;
            4'd6: seg = 8'b10000010;
            4'd7: seg = 8'b11111000;
            4'd8: seg = 8'b10000000;
            4'd9: seg = 8'b10010000;
            4'd10: seg = 8'b10001110;
            4'd11: seg = 8'b10000011;
            default: seg = 8'b11111111;
        endcase
    end
endmodule