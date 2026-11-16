`timescale 1ns/1ps

module alu_control (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7_b5,
    output reg alu_ctrl[3:0]
);
    localparam OP_ADD = 2'b00, //force add
                OP_SUB = 2'b01, // force subtract/compare
                OP_RTYPE = 2'b10, // decode {funct7_b5, funct3}
                OP_ITYPE = 2'b11; // decode funct3, bit 30 forced to 0

    localparam  ADD = 4'b0000,
                SUB = 4'b1000,

    always @(*) begin
        case (ALUOp)
            OP_ADD: alu_ctrl = ADD;
            OP_SUB: alu_ctrl = SUB;
            OP_RTYPE: alu_ctrl = {funct7_b5, funct3};
            OP_ITYPE: alu_ctrl = {1'b0, funct3};
            default: 4'b0000;
        endcase
    end

endmodule