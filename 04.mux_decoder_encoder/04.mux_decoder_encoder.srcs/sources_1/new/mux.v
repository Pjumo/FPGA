`timescale 1ns / 1ps

// module mux2_1(
//     input a,    // 첫번째 입력
//     input b,    // 두번째 입력
//     input sel,
//     output out  // 출력
// );

//     assign out = sel ?  a : b;
// endmodule

// module mux2_1(
//     input a,    // 첫번째 입력
//     input b,    // 두번째 입력
//     input sel,
//     output out  // 출력
// );

//     reg r_out;

//     // always @(sel, a, b) begin
//     //     if(sel) r_out = a;
//     //     else r_out = b;
//     // end
//     // assign out = r_out;
    
//     always @(*) begin
//         case (sel)
//             1'b1: r_out = a; 
//             default: r_out = b;
//         endcase
//     end
//     assign out = r_out;
// endmodule


module mux2_1(
    input [3:0] a,    // 첫번째 입력
    input [3:0] b,    // 두번째 입력
    input sel,
    output [3:0] out  // 출력
);

    reg [3:0] r_out;
    
    always @(*) begin
        if(sel) r_out = a;
        else r_out = b;
    end
    assign out = r_out;
endmodule
