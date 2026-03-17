`timescale 1ns / 1ps

module circular_queue_v2(
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
    parameter ASCII_CR = 8'h0D;
    parameter ASCII_LF = 8'h0A;

    reg [7:0] c_queue [15:0];
    reg [3:0] rear, front;  // overflow로 circlular queue rear, front 역할 수행 가능
    reg check_led_on, check_led_off;
    integer i;
    
    // push 동작
    task push();
    begin
        c_queue[front] <= rx_data;
        front <= front + 1;
        // front가 rear와 겹치지 않게 rear 밀기
        if(front == rear - 1)
            rear <= rear + 1;
    end
    endtask

    // led0on 비교용
    task check_command_on();
    begin
        if((c_queue[(front<6)?(front+10):(front-6)] == ASCII_L) &&
        (c_queue[(front<5)?(front+11):(front-5)] == ASCII_E) &&
        (c_queue[(front<4)?(front+12):(front-4)] == ASCII_D) &&
        (c_queue[(front<3)?(front+13):(front-3)] == ASCII_0) &&
        (c_queue[(front<2)?(front+14):(front-2)] == ASCII_O) &&
        (c_queue[(front<1)?(front+15):(front-1)] == ASCII_N)) begin
            check_led_on <= 1;
        end else begin
            check_led_on <= 0;
            // pop 동작 대신 rear를 front로
            // rear to front의 data를 pop 시키는 효과
            rear <= front;
        end
    end
    endtask

    // led0off 비교용
    task check_command_off();
    begin
        if((c_queue[(front<7)?(front+9):(front-7)] == ASCII_L) &&
        (c_queue[(front<6)?(front+10):(front-6)] == ASCII_E) &&
        (c_queue[(front<5)?(front+11):(front-5)] == ASCII_D) &&
        (c_queue[(front<4)?(front+12):(front-4)] == ASCII_0) &&
        (c_queue[(front<3)?(front+13):(front-3)] == ASCII_O) &&
        (c_queue[(front<2)?(front+14):(front-2)] == ASCII_F) &&
        (c_queue[(front<1)?(front+15):(front-1)] == ASCII_F)) begin
            check_led_off <= 1;
        end else begin
            check_led_off <= 0;
            rear <= front;
        end
    end
    endtask

    // rx_done 상승에지 마다 push, command check
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            for(i=0;i<16;i=i+1) begin
                c_queue[i] <= 0;
            end
            rear <= 0;
            front <= 0;
            check_led_on <= 0;
            check_led_off <= 0;
            led[0] <= 0;
        end else begin
            if(rx_done) begin
                if(rx_data == ASCII_LF) begin
                    check_command_on();
                    check_command_off();
                end else if(rx_data != ASCII_CR) begin
                    push();
                end
            end
        end
    end

    // led[0] 상태 변화 감지
    always @(posedge clk) begin
        if(check_led_on)
            led[0] <= 1;
        if(check_led_off)
            led[0] <= 0;
    end
endmodule
