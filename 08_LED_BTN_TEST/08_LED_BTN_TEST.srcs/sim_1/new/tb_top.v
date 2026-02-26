`timescale 1ns / 1ps

module tb_top();
    reg clk, reset, btn;
    wire [15:0] led;

    parameter TICK_Hz = 2_000_000;
    parameter TICK_freq = 100_000_000 / TICK_Hz * 10;

    top #(.TICK_Hz(TICK_Hz)) u_top(
        .clk    (clk),
        .reset  (reset),
        .btn    (btn),
        .led    (led)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task push_btn;
    begin
        btn = 1; #TICK_freq
        btn = 0; #(TICK_freq*2)
        btn = 1; #(TICK_freq*3)
        btn = 0; #TICK_freq
        btn = 1; #(TICK_freq*12)
        btn = 0;
    end
    endtask

    initial begin
        reset = 1; btn = 0; #50
        reset = 0;

        #(TICK_freq * 1000)  // mode 1
        push_btn;
        #(TICK_freq * 1000)   // mode 2
        push_btn;
        #(TICK_freq * 1000)   // mode 3
        push_btn;
        #(TICK_freq * 1000)   // mode 4
        push_btn;
        #(TICK_freq * 1000)   // mode 1
        $finish;
    end
endmodule
