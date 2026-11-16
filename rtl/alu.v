`timescale 1ns/1ps
module alu (
    input [31:0] a, // rs1
    input [31:0] b, // rs2 or immediate
    input [3:0] alu_ctrl, // {funct7_b5, funct3}
    output [31:0] result,
    output zero // one if result is zero
);
    localparam  ADD = 4'b0000;
                SUB = 4'b1000;
                AND = 4'b0111;
                OR = 4'b0110;
                XOR = 4'b0100;
                SLT = 4'b0010;

    assign zero = (result == 0);
    always @(*) begin
        case (alu_ctrl)
            ADD: result = a + b;
            SUB: result = a - b;
            AND: result = a & b;
            OR: result = a | b;
            XOR: result = a ^ b;
            SLT: result = ($signed(a) < signed(b))? 1'b1:1'b0;
            default: result = 32'b0;
        endcase

    end

endmodule

