`timescale 1ns / 1ps

module shift_register(
    input clk,
    input reset,
    input btnU,
    input btnD,
    output [15:0] led
);

// btnU를 누르면 1, btnD를 누르면 0으로 입력되도록 한다.
// 버튼을 누를때마다 1bit씩 shift 하면서
// shift register가 동작 되도록 하며 shift되는
// 동작 값이 led1~led7에 표시되도록 한다.
// 만약 입력값이 1010111이면 led0이 켜지도록 구현한다.

    reg [6:0] sr7;
    wire [1:0] w_debounced_btn;
    reg [1:0] r_prev_btn = 0;

    btn_debouncer u_btn_debouncer(
        .clk(clk),
        .btn({btnU, btnD}),
        .debounced_btn(w_debounced_btn)
    );

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            sr7 <= 7'b0000000;
        end else begin
            if(w_debounced_btn[0] && !r_prev_btn[0]) begin
                sr7 <= {sr7[5:0], 1'b0};
            end else if(w_debounced_btn[1] && !r_prev_btn[1]) begin
                sr7 <= {sr7[5:0], 1'b1};
            end
        end
        r_prev_btn = w_debounced_btn;
    end

    assign led[0] = (sr7 == 7'b1010111) ? 1 : 0;
    assign led[7:1] = sr7;

endmodule
