`timescale 1ns / 1ps

module tb_button_debounce();

    parameter CLK_FREQ = 100_000_000;   // 100MHz
    parameter CLK_PERIOD = 10;  // 10ns
    parameter BTN_PRESS_LIMIT = 30_000_000;

    reg clk;
    reg reset;
    reg btnC;
    wire [1:0] led;

    top_btn top_btn_test(
        .clk    (clk),
        .reset  (reset),
        .btnC   (btnC),
        .led    (led)
    );

    initial begin
        clk = 0;
        forever #5 begin
            clk = ~clk;
        end
    end

    initial begin
        reset = 1;
        btnC = 0;
        #100;
        reset = 0;
        $display("[%0t] start btn noise generation....", $time);
        #100 btnC = 1;
        #200 btnC = 0;
        #200 btnC = 1;
        #120 btnC = 0; // bounce 구현
        #300 btnC = 1;
        #BTN_PRESS_LIMIT;
        if(led !== 2'b00) begin
            $display("[%0t] test passed led changed....", $time);
        end else begin
            $display("[%0t] test failed....", $time);
        end
        #1000;
        $display("======== simulation finish =============");
        $finish;
    end
endmodule
