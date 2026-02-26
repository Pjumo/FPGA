`timescale 1ns / 1ps

module fsm_pattern(
    input wire clk,
    input wire reset,
    input wire in,
    output reg out
);

    parameter START = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4;

    reg [2:0] current_state = START;
    reg [2:0] next_state;

    always @(*) begin
        case(current_state)
        START: next_state = (in) ? START : S1;
        S1: next_state = (in) ? S2 : S1;
        S2: next_state = (in) ? S3 : S1;
        S3: next_state = (in) ? START : S4;
        S4: next_state = (in) ? S2 : S1;
        default: next_state = START;   // latch 방지를 위해
        endcase
    end

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            current_state <= START;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        out = 1'b0;     // 기본값 설정: latch 방지 위해서
        
        case(current_state)
        S4: 
            out = 1;
        default: 
            out = 0;
        endcase
    end

endmodule
