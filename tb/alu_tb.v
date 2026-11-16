`timescale 1ns/1ps 

module alu_tb;
reg [31:0] a, b;
reg [3:0] alu_ctrl;
wire [31:0] result;
wire zero;

alu DUT(
    .a(a),
    .b(b),
    .alu_ctrl(alu_ctrl),
    .result(result),
    .zero(zero)
);

localparam  ADD = 4'b0000,
            SUB = 4'b1000,
            AND = 4'b0111,
            OR = 4'b0110,
            XOR = 4'b0100,
            SLT = 4'b0010;

initial begin 
    a = 32'd5; b = 32'd7;
    alu_ctrl = ADD;
    #10;
    if (result === 32'd12)
        $display("PASS: ADD  %0d + %0d = %0d", a, b, result);
    else
        $display("FAIL: ADD  %0d + %0d: expected %0d, got %0d", a, b, 32'd12, result);
    
end


endmodule