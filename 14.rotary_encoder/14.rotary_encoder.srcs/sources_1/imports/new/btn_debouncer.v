
module debouncer #(parameter DEBOUNCE_LIMIT = 1_000_000) (
  input clk,
  input noisy_btn,
  output reg clean_btn = 0
);
    reg [19:0] count = 0;
    reg btn_state = 0;

    always @(posedge clk) begin
        if (noisy_btn == btn_state) begin
            count <= 0;
        end else begin
            count <= count + 1;
            if (count >= DEBOUNCE_LIMIT) begin
                btn_state <= noisy_btn;
                clean_btn <= noisy_btn;
                count <= 0;
            end
        end
    end
endmodule