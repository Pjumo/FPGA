`timescale 1ns / 1ps

module gatetest(
    input wire a,
    input b,    // wire를 생략하면 default로 wire다.
                // 아무런 언급이 없으면 1bit로 인식한다.
    output [4:0] led    // led[0]~led[4]
    );

    assign led[0] = a&b;    // 연속 할당문 assign: 연결하라는 의미
    assign led[1] = a|b;
    assign led[2] = ~(a&b);
    assign led[3] = ~(a|b);
    assign led[4] = a^b;
endmodule