`timescale 1ns / 1ps

module tb_uart_rx();
    reg clk;
    reg reset;
    reg rx;
    wire [7:0] data_out;
    wire rx_done;

    uart_rx #(
        .BPS(9600)
    ) u_uart_rx(
        .clk        (clk),
        .reset      (reset),
        .rx         (rx),
        .data_out   (data_out),
        .rx_done    (rx_done)
    );

    always #5 clk = ~clk;

    localparam CLK_FREQUENCY = 100_000_000; // 100MHz
    localparam BIT_PER_CLK_NUM = CLK_FREQUENCY / 9600;  // 1bit당 10ns의 clk이 몇개 필요한가
    localparam CLK_PERIOD = 10; // 10ns
    localparam BAUD_PERIOD = BIT_PER_CLK_NUM * CLK_PERIOD;  // simulation wait 시간
    integer i;

    always @(posedge rx_done) begin
        $display("time: %t) data_out received: %h", $time, data_out);
    end

    task send_rx_data(
        input [7:0] data
    );
        for(i=7;i>=0;i=i-1) begin
            rx = data[i];
            #BAUD_PERIOD;
        end
    endtask

    // URT RX simulator
    // ASCII 'U' 와 'u'를 uart_rx로 전송
    initial begin
        clk = 0; reset = 1; rx = 1;
        #100;
        reset = 0;
        #200;

        rx = 0; // start bit
        #BAUD_PERIOD;
        send_rx_data(8'b10101010);  // 'U' 0x55 01010101
        rx = 1; // stop bit
        #1_000_000;

        $display("UART RX test finish.....");
        $finish;
    end
endmodule
