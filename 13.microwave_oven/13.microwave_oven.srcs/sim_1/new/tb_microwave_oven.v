`timescale 1ns / 1ps

module tb_microwave_oven();
    reg clk;
    reg reset;
    reg [4:0] btn;
    wire buzzer;
    wire PWM_OUT;
    wire SERVO_PWM_OUT;
    wire [1:0] in1_in2;
    wire led;
    wire [7:0] seg;
    wire [3:0] an;

    microwave_oven u_microwave_oven(
        .clk            (clk),
        .reset          (reset),
        .btnU           (btn[0]),
        .btnL           (btn[1]),
        .btnC           (btn[2]),
        .btnR           (btn[3]),
        .btnD           (btn[4]),
        .buzzer         (buzzer),
        .PWM_OUT        (PWM_OUT),
        .SERVO_PWM_OUT  (SERVO_PWM_OUT),
        .in1_in2        (in1_in2),
        .led            (led),
        .seg            (seg),
        .an             (an)
    );

    always #5 clk = ~clk;

    task push_btn;
    input integer index;
    begin
        btn[index] = 1; #1_200_000
        btn[index] = 0;
    end
    endtask

    initial begin
        clk = 0;
        reset = 1;
        #100 reset = 0;
    end
endmodule
