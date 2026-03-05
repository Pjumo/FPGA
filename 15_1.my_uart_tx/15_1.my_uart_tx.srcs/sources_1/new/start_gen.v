`timescale 1ns / 1ps

module start_gen(
    input clk,
    input reset,
    input btn,
    output reg start_trigger
);
    reg ff1;
    reg ff2;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            ff1 <= 0;
            ff2 <= 0;
            start_trigger <= 0;
        end else begin
            ff1 <= btn;
            ff2 <= ff1;
            if(!ff2 && ff1) begin
                start_trigger <= 1;
            end else begin
                start_trigger <= 0;
            end
        end
    end
endmodule
