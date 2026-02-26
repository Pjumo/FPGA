`timescale 1ns / 1ps

module testbench_fadder();
    reg c_in, a, b;
    wire sum, carry_out;
    
    fadder fadder_test(
        .carry_in   (c_in),
        .a          (a),
        .b          (b),
        .sum        (sum),
        .carry_out  (carry_out)
    );

    initial begin
        #00 c_in=0; a=0; b=0;
        #10 c_in=0; a=0; b=1;
        #10 c_in=0; a=1; b=0;
        #10 c_in=0; a=1; b=1;
        #10 c_in=1; a=0; b=0;
        #10 c_in=1; a=0; b=1;
        #10 c_in=1; a=1; b=0;
        #10 c_in=1; a=1; b=1;
        #10 $finish;
    end
endmodule
