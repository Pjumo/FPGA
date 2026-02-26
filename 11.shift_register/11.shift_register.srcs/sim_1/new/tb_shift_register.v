`timescale 1ns / 1ps

module tb_shift_register();
    reg clk;
    reg reset;
    reg btnU = 0;
    reg btnD = 0;
    wire [15:0] led;

    shift_register u_shift_register(
        .clk    (clk),
        .reset  (reset),
        .btnU   (btnU),
        .btnD   (btnD),
        .led    (led)
    );

    always #5 clk=~clk;

    initial begin
        clk = 0;
        reset = 1;
        #100 reset = 0;

        btnU = 1;
        #12000000;
        btnU = 0;
        #10000;
        btnD = 1;
        #12000000;
        btnD = 0;
        #10000;
        btnU = 1;
        #12000000;
        btnU = 0;
        #10000;

        #100;
        $display("===== simulation finished !!!!");
        $finish;
    end

endmodule
