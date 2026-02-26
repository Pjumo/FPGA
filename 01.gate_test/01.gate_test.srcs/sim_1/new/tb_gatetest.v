`timescale 1ns / 1ps    // 1.999ns

module tb_gatetest();
    reg i_a, i_b;   // a라는 변수는 1bit 자리 저장 memory
    wire [4:0] o_led;

    // named port mapping 방식
    gatetest u_gatetest(    // u_gatetest라는 이름으로 인스턴스화
        .a(i_a),
        .b(i_b),
        .led(o_led)
    );

    initial begin
        #00 i_a = 1'b0; i_b = 1'b0;
        #20 i_a = 1'b0; i_b = 1'b1;
        #20 i_a = 1'b1; i_b = 1'b0;
        #20 i_a = 1'b1; i_b = 1'b1;
        #20 $finish;
    end
endmodule
