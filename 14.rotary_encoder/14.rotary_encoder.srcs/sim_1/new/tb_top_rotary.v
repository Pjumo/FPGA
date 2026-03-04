`timescale 1ns / 1ps

module tb_top_rotary();
    reg clk;
    reg reset;
    reg s1;
    reg s2;
    reg key;
    wire [15:0] led;

    top_rotary #(.DEBOUNCE_LIMIT_S(200), .DEBOUNCE_LIMIT_KEY(200)) u_top_rotary(
        .clk    (clk),
        .reset  (reset),
        .s1     (s1),
        .s2     (s2),
        .key    (key),
        .led    (led)
    );

    // 일괄적으로 50ns x 3 noise를 만듦
    task make_btn_noise(input integer sw);  // 0: s1, 1: s2
        begin
            repeat(3) begin
                if(sw == 0) s1 = ~s1;
                else if(sw == 1) s2 = ~s2;
                else key = ~key;
                #50;
            end
        end
    endtask

    always #5 clk = ~clk;

    initial begin
        clk = 0; s1 = 0; s2 = 0; key = 0;
        reset = 1;
        #100;
        reset = 0;
        #100;

        $display("CW TEST start.....");
        make_btn_noise(0); s1 = 1;  #3000;  // 200cycle (10ns x 200 = 2000ns) : noise 보다 긴 3000ns 대기
        make_btn_noise(1); s2 = 1;  #3000;  // 200cycle (10ns x 200 = 2000ns) : noise 보다 긴 3000ns 대기
        s1 = 0; #3000;
        s2 = 0; #3000;

        $display("CCW TEST start.....");
        make_btn_noise(1); s2 = 1;  #3000;  // 200cycle (10ns x 200 = 2000ns) : noise 보다 긴 3000ns 대기
        make_btn_noise(0); s1 = 1;  #3000;  // 200cycle (10ns x 200 = 2000ns) : noise 보다 긴 3000ns 대기
        s2 = 0; #3000;
        s1 = 0; #3000;

        $display("Key Toggle Test start.......");
        make_btn_noise(2); key = 1; #3000;  // rising edge detect!
        key = 0; #3000;

        $display("Simulation finished.......");
        $finish;
    end

    initial begin
        $monitor("time = %t, r_counter: %h, r_direction: %b, r_led_toggle: %b", 
            $time, led[7:0], led[15:14], led[13]);
    end
endmodule
