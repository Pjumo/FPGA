`timescale 1ns / 1ps

module tb_top();
    reg clk;
    reg reset;
    reg [2:0] btn;
    wire [7:0] seg;
    wire [3:0] an;

    parameter TICK_Hz = 10_000_000;
    parameter TICK_freq = 100_000_000 / TICK_Hz * 10;

    top #(.TICK_Hz(TICK_Hz)) u_top(
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .seg(seg),
        .an(an)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task push_btn;
    input integer btn_index;
    begin
        btn[btn_index] = 1; #TICK_freq
        btn[btn_index] = 0; #(TICK_freq*2)
        btn[btn_index] = 1; #(TICK_freq*3)
        btn[btn_index] = 0; #TICK_freq
        btn[btn_index] = 1; #(TICK_freq*12)
        btn[btn_index] = 0;
    end
    endtask

    initial begin
        reset = 1; btn = 0; #50
        reset = 0;

        #(TICK_freq * 1000)
        push_btn(0);
        #(TICK_freq * 1000)
        push_btn(0);
        #(TICK_freq * 1000)
        push_btn(0);
        #(TICK_freq * 1000)
        push_btn(2);
        #(TICK_freq * 6000)

        push_btn(0);
        #(TICK_freq * 1000)
        push_btn(0);
        #(TICK_freq * 1000)
        push_btn(0);
        #(TICK_freq * 1000)
        push_btn(1);
        #(TICK_freq * 1000)
        $finish;
    end
endmodule
