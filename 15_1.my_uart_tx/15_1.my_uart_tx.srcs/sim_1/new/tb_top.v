`timescale 1ns / 1ps

module tb_top();
    reg clk;
    reg reset;
    reg [7:0] sw;
    reg btn;
    reg RsRx;
    wire RsTx;

    top #(
        .BPS(1_000_000),
        .DEBOUNCE_LIMIT(999)   // 10us
    ) u_top(
        .clk    (clk),
        .reset  (reset),
        .sw     (sw),
        .btnL   (btn),
        .RsRx   (RsRx),
        .RsTx   (RsTx)
    );

    task btn_press;
        begin
            btn = 1;
            #100;
            btn = 0;
            #200;
            btn = 1;
            #150;
            btn = 0;
            #100;
            // btn 안정구간
            btn = 1;
            #11000;
            // btn 떼기
            btn = 0;
        end
    endtask

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; 
        #100;
        reset = 0;
        
        sw = 8'h50; // P
        btn_press;
        #20000;
        
        sw = 8'h4A; // J
        btn_press;
        #20000;
        
        sw = 8'h4D; // M
        btn_press;
        #20000;

        $finish;
    end
endmodule
