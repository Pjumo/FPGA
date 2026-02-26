`timescale 1ns / 1ps

module encoder(
    input [3:0] a,
    output [1:0] out
);
    
    // assign out = (a == 4'b0001) ? 2'b00 : 
    //             (a == 4'b0010) ? 2'b01 : 
    //             (a == 4'b0100) ? 2'b10 : 2'b11;

    reg [1:0] r_out;

    always @(*) begin
        if(a == 4'b0001) r_out = 2'b00;
        else if(a == 4'b0010) r_out = 2'b01;
        else if(a == 4'b0100) r_out = 2'b10;
        else r_out = 2'b11;
    end

    assign out = r_out;
endmodule
