`timescale 1ns / 1ps

module circular_queue_v1(
    input clk,
    input reset,
    input rx_done,
    input [7:0] rx_data,
    output reg [15:0] led
);
    parameter ASCII_L = 8'h6C;
    parameter ASCII_E = 8'h65;
    parameter ASCII_D = 8'h64;
    parameter ASCII_0 = 8'h30;
    parameter ASCII_O = 8'h6F;
    parameter ASCII_N = 8'h6E;
    parameter ASCII_F = 8'h66;

    reg [7:0] c_queue [15:0];
    reg [3:0] rear, front;  // overflow로 circlular queue rear, front 역할 수행 가능
    reg [2:0] check_led_on, check_led_off;
    integer i, c;
    
    task push();
    begin
        c_queue[front] = rx_data;
        front = front + 1;
        if(front == rear)
            rear = rear + 1;
    end
    endtask

    // 일반적인 pop 과정과는 다른데, 이 문제의 경우 매번 pop을 해서 비교하는 것이 아닌
    // 일괄적으로 확인하는 방식이라 전체 버림을 사용함.
    task pop(); // return 없이 data 전체 버림
    begin
        for(i=0;i<16;i=i+1) begin
            c_queue[i] <= 0;
        end
        rear <= 0;
        front <= 0;
    end
    endtask

    task check_command_on();
    begin
        check_led_on = 0;
        for(i=0;i<6;i=i+1) begin
            c = (front - 6 + i < 0) ? (front + i + 10) : (front + i - 6);
            if((c_queue[c] == ASCII_L && check_led_on == 0) ||
               (c_queue[c] == ASCII_E && check_led_on == 1) ||
               (c_queue[c] == ASCII_D && check_led_on == 2) ||
               (c_queue[c] == ASCII_0 && check_led_on == 3) ||
               (c_queue[c] == ASCII_O && check_led_on == 4) ||
               (c_queue[c] == ASCII_N && check_led_on == 5)) begin
                check_led_on = check_led_on + 1;
            end
        end
    end
    endtask

    task check_command_off();
    begin
        check_led_off = 0;
        for(i=0;i<7;i=i+1) begin
            c = (front - 7 + i < 0) ? (front + i + 9) : (front + i - 7);
            if((c_queue[c] == ASCII_L && check_led_off == 0) ||
               (c_queue[c] == ASCII_E && check_led_off == 1) ||
               (c_queue[c] == ASCII_D && check_led_off == 2) ||
               (c_queue[c] == ASCII_0 && check_led_off == 3) ||
               (c_queue[c] == ASCII_O && check_led_off == 4) ||
               (c_queue[c] == ASCII_F && check_led_off == 5) ||
               (c_queue[c] == ASCII_F && check_led_off == 6)) begin
                check_led_off = check_led_off + 1;
            end
        end
    end
    endtask

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            for(i=0;i<16;i=i+1) begin
                c_queue[i] <= 0;
            end
            rear <= 0;
            front <= 0;
        end else begin
            if(rx_done) begin
                if(rx_data == 8'h0A) begin  // 개행문자 LF가 들어왔을 때 검사
                    if((front-rear < 0) ? (front-rear+16) : (front-rear) > 6) begin
                        check_command_on();
                        if(check_led_on == 6) begin
                            led[0] <= 1;
                            pop();
                        end
                    end

                    if((front-rear < 0) ? (front-rear+16) : (front-rear) > 7) begin
                        check_command_off();
                        if(check_led_off == 7) begin
                            led[0] <= 0;
                            pop();
                        end
                    end
                end else if(rx_data != 8'h0D) begin // 개행문자 아니면 계속 push
                    push();
                end
            end
        end
    end
endmodule
