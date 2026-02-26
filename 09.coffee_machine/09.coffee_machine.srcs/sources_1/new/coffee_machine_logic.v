`timescale 1ns / 1ps

module coffee_machine_logic(
    input tick,
    input reset,
    input seg_en,
    input coin_return,
    input coffee_make,
    input [15:0] coin_val,
    output reg coffee_out,
    output reg [13:0] in_data
);
    parameter IDLE_SEG = 14'b11111111111111;
    reg [12:0] counter_5s = 0;

    always @(posedge tick, posedge reset) begin
        coffee_out <= 0;
        if(reset) begin
            in_data <= 0;
            counter_5s <= 0;
        end else begin
            if(seg_en) begin
                if(coin_return) begin
                    in_data <= 0;
                end else if(coffee_make) begin
                    in_data <= IDLE_SEG;
                    if(counter_5s == 4999) begin
                        counter_5s <= 0;
                        coffee_out <= 1;
                    end else begin
                        counter_5s <= counter_5s + 1;
                    end
                end else begin
                    in_data <= coin_val;
                end
            end else begin
                in_data <= 0;
            end
        end
    end
endmodule
