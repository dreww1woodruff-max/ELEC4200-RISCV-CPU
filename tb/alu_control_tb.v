`timescale 1ns/1ps

module alu_control_tb;
reg [1:0] ALUOp;
reg [2:0] funct3;
reg funct7_b5;
wire [3:0] alu_ctrl;

alu_control DUT (
    .ALUOp(ALUOp),
    .funct3(funct3),
    .funct7_b5(funct7_b5),
    .alu_ctrl(alu_ctrl)
);

localparam      OP_ADD = 2'b00, //force add
                OP_SUB = 2'b01, // force subtract/compare
                OP_RTYPE = 2'b10, // decode {funct7_b5, funct3}
                OP_ITYPE = 2'b11; // decode funct3, bit 30 forced to 0

    localparam  ADD = 4'b0000,
                SUB = 4'b1000;

integer pass_count, fail_count;

task check;
    input [1:0] op;
    input [2:0] f3;
    input       f7b5;
    input [3:0] expected;
    input [8*8-1:0] name;
    begin
        ALUOp = op; funct3 = f3; funct7_b5 = f7b5;
        #10;
        if (expected === alu_ctrl) begin
            $display("PASS: %s  ALUOp=%b funct3=%b b30=%b alu_ctrl=%b",
                     name, ALUOp, funct3, funct7_b5, alu_ctrl);
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: %s  ALUOp=%b funct3=%b b30=%b expected=%b, got=%b",
                     name, ALUOp, funct3, funct7_b5, expected, alu_ctrl);
            fail_count = fail_count + 1;
        end
    end
endtask

initial begin
    pass_count = 0;
    fail_count = 0;

    check(OP_RTYPE, 3'b000, 1'b0, ADD, "ADD");
    check(OP_RTYPE, 3'b000, 1'b1, SUB, "SUB");
end
endmodule