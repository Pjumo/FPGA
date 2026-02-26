`timescale 1ns / 1ps

module tb_fsm_pattern();

    reg clk;
    reg reset;
    reg in;
    wire out;

    fsm_pattern u_fsm_pattern(
        .clk    (clk),
        .reset  (reset),
        .in     (in),
        .out    (out)
    );

    always #5 clk=~clk;

    // 값이 변하면 값을 출력한다.
    initial begin
        $monitor("time=%t state=%b, in=%b, out=%b", $time, u_fsm_pattern.current_state, in, out);
    end

    initial begin
        clk = 0;
        reset = 1;
        in = 0;
        #100 reset = 0;

        // #1_test pattern 1010111 10ns(1주기마다 1bit씩 날린다)
        @(posedge clk); in = 1;
        @(posedge clk); in = 0;
        @(posedge clk); in = 1;
        @(posedge clk); in = 0;
        @(posedge clk); in = 1;
        @(posedge clk); in = 1;
        // S6 -> S1 : 여기서 out이 1이 되어야 한다.
        @(posedge clk); in = 1;

        // #2_test pattern 011
        @(posedge clk); in = 0;
        @(posedge clk); in = 1;
        @(posedge clk); in = 1;

        // #3_test pattern 010111 (#2 마지막 1과 결합되는지)
        @(posedge clk); in = 0;
        @(posedge clk); in = 1;
        @(posedge clk); in = 0;
        @(posedge clk); in = 1;
        @(posedge clk); in = 1;
        @(posedge clk); in = 1;

        #100;
        $display("===== simulation finished !!!!");
        $finish;
    end

endmodule
