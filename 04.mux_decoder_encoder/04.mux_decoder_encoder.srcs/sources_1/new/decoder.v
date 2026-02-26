`timescale 1ns / 1ps


module decoder(
    input [1:0] a,
    output [3:0] out
);

    // assign out = (a == 2'b00) ? 4'b0001 : 
    //             (a == 2'b01) ? 4'b0010 : 
    //             (a == 2'b10) ? 4'b0100 : 4'b1000;

    reg [3:0] r_out;
    always @(*) begin
        if(a == 2'b00) r_out = 4'b0001;
        else if(a == 2'b01) r_out = 4'b0010;
        else if(a == 2'b10) r_out = 4'b0100;
        else r_out = 4'b1000;
    end

    assign out = r_out;
endmodule
