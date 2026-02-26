`timescale 1ns / 1ps

// module tb_mux2_1();
//     // 입력: reg 출력 : wire
//     reg a, b;
//     reg sel;
//     wire out;

//     mux2_1 u_mux2_1(
//         .a      (a),
//         .b      (b),
//         .sel    (sel),
//         .out    (out)
//     );

//     // test scenario 작성
//     initial begin
//         // 초기값 설정
//         a = 0; b = 0; sel = 0;
//         // 결과 출력
//         $monitor("Time = %0t | sel = %b, a = %b, b = %b, out = %b", $time, sel, a, b, out);
//         // --- sel :1 (a 출력)
//         #10 sel = 1; a = 1; b = 0;  // out : 1
//         #10 sel = 1; a = 0; b = 1;  // out : 0
//         // --- sel :0 (b 출력)
//         #10 sel = 0; a = 1; b = 0;  // out : 0
//         #10 sel = 0; a = 0; b = 1;  // out : 1
//         #10 $finish;
//     end
// endmodule


module tb_mux2_1();
    // 입력: reg 출력 : wire
    reg [3:0] a, b;
    reg sel;
    wire [3:0] out;

    mux2_1 u_mux2_1(
        .a      (a),
        .b      (b),
        .sel    (sel),
        .out    (out)
    );

    // test scenario 작성
    initial begin
        // 초기값 설정
        a = 4'hA; b = 4'h3; sel = 0;
        // 결과 출력
        $monitor("Time = %0t | sel = %b, a = %h, b = %h, out = %h", $time, sel, a, b, out);
        // --- sel :1 (a 출력)
        #10 sel = 1; a = 4'hE; b = 4'h7;  // out : E
        #10 sel = 1; a = 4'hF; b = 4'hA;  // out : F
        // --- sel :0 (b 출력)
        #10 sel = 0; a = 4'b1; b = 4'b0;  // out : 0
        #10 sel = 0; a = 4'b0; b = 4'b1;  // out : 1
        #10 $finish;
    end
endmodule
