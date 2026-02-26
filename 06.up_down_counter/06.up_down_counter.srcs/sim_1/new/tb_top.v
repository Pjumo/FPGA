`timescale 1ns / 1ps

module tb_top();
    reg clk;
    reg reset;
    reg [2:0] btn;
    reg [7:0] sw;
    wire [7:0] seg;
    wire [3:0] an;
    wire [15:0] led;

    top u_top(
        .clk    (clk),
        .reset  (reset),
        .btn    (btn),
        .sw     (sw),
        .seg    (seg),
        .an     (an),
        .led    (led)
    );

    // 100MHz clock 생성 (10ns 주기)
    always #5 clk = ~clk;

    task btn_press;
        input integer btn_index;
        begin
            $display("btn_press btn:%0d start", btn_index);

            // make noise(0.55ms)
            btn[btn_index] = 1;
            #100000;    // 0.1ms high
            btn[btn_index] = 0;
            #200000;    // 0.2ms low
            btn[btn_index] = 1;
            #150000;    // 0.15ms high
            btn[btn_index] = 0;
            #100000;    // 0.1ms low
            // 안정구간 11ms 유지
            btn[btn_index] = 1;
            #11000000;
            // btn 떼기
            btn[btn_index] = 0;
            #11000000;

            $display("btn_press btn:%0d end", btn_index);
        end
    endtask

    initial begin
        $monitor("time=%t mode:%b an:%b seg:%b", $time, led[15:13], an, seg);
        // 값이 바뀌면 해당 라인 출력
    end

    initial begin
        // 1. initial 설정
        clk = 0;
        reset = 1;
        btn = 3'b000;
        sw = 8'b00000000;

        // 2. reset 해제
        #100;
        reset = 0;
        #100;

        // 3. mode 변경 (IDLE --> UP_COUNTER)
        $display("MODE IDLE --> UP_COUNTER");
        btn_press(0);   // btn[0]
        // 4. UP_COUNTER 동작 관찰
        #20000000;  // 20ms

        //------ 모드 변경 UP --> DOWN
        $display("UP_COUNTER --> DOWN_COUNTER");
        btn_press(0);   // btn[0]
        #10000000;  // 10ms

        //------ 모드 변경 DOWN --> SLIDE_SW_READ
        $display("DOWN_COUNTER --> SLIDE_SW_READ");
        btn_press(0);   // btn[0]
        sw = 8'h55;
        #100000;
        sw = 8'hAA;
        #100000;

        $display("simulation Ended........");
        $finish;
    end
endmodule