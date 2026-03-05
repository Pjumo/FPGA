module btn_debouncer(
    input clk,
    input reset,
    input [2:0] btn,
    output [2:0] debounced_btn
);
    debouncer U_debouncer_btnL (
        .clk(clk),
        .reset(reset),
        .noisy_btn(btn[0]),
        .clean_btn(debounced_btn[0])
    );

    debouncer U_debouncer_btnC (
        .clk(clk),
        .reset(reset),
        .noisy_btn(btn[1]),
        .clean_btn(debounced_btn[1])
    );

    debouncer U_debouncer_btnR (
        .clk(clk),
        .reset(reset),
        .noisy_btn(btn[2]),
        .clean_btn(debounced_btn[2])
    );
endmodule

module debouncer #(parameter DEBOUNCE_LIMIT = 20'd999_999) (
    input      clk,
    input      reset,
    input      noisy_btn,
    output reg clean_btn
);
    reg [19:0] count;
    reg btn_state=0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            btn_state <= 0;
            clean_btn <= 0;
        end else if (noisy_btn == btn_state) begin
            count <= 0;
        end else begin
            if (count < DEBOUNCE_LIMIT)
                count <= count + 1;
            else begin
                btn_state <= noisy_btn;
                clean_btn <= noisy_btn;
                count <= 0;
            end
        end
    end
endmodule

