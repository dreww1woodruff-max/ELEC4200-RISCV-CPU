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
integer pass_count, fail_count;

task check;
    input [3:0] ctrl;
    input [31:0] in_a, in_b, expected;
    input [8*8-1:0] name;
    begin
        alu_ctrl = ctrl; a = in_a; b = in_b;
        #10;
        if (expected === result) begin
            $display("PASS: %s  a=%08h b=%08h result=%08h", name, a, b, result);
            pass_count = pass_count + 1;
        end
        
        else begin
            $display("FAIL: %s  a=%08h b=%08h expected=%08h, got=%08h", name, a, b, expected, result);
            fail_count = fail_count + 1;
        end
    end 
endtask 
initial begin
    pass_count = 0;
    fail_count = 0;

    check(ADD , 32'd5, 32'd7, 32'd12, "ADD");                    // normal add
    check(ADD , 32'h7FFF_FFFF, 32'h1, 32'h8000_0000, "ADD");     // signed overflow
    check(ADD , 32'hFFFF_FFFF, 32'h1, 32'h0, "ADD");             // unsigned overflow

    check(SUB , 32'h0000_000F, 32'h5, 32'hA, "SUB");             // normal sub
    check(SUB , 32'h0000_FFF0, 32'h1, 32'h0000_FFEF, "SUB");     // normal sub
    check(SUB , 32'h0000_0000, 32'h1, 32'hFFFF_FFFF, "SUB");     // wraparound
    check(SUB , 32'h1234_5678, 32'h1234_5678, 32'h0, "SUB");     // equal operands 

    check(AND , 32'h00FF_FFFF, 32'h00FF_0000, 32'h00FF_0000, "AND");
    check(OR  , 32'h0000_FFFF, 32'hFFFF_0000, 32'hFFFF_FFFF, "OR");
    check(XOR , 32'hFFFF_FFFF, 32'hFFFF_FFFF, 32'h0, "XOR");

    // AND/OR/XOR on the same operands, so a swapped operator is caught
    check(AND , 32'hF0F0_F0F0, 32'hFF00_FF00, 32'hF000_F000, "AND");
    check(OR  , 32'hF0F0_F0F0, 32'hFF00_FF00, 32'hFFF0_FFF0, "OR");
    check(XOR , 32'hF0F0_F0F0, 32'hFF00_FF00, 32'h0FF0_0FF0, "XOR");

    check(SLT , 32'h0000_0000, 32'h1, 32'h1, "SLT");             // 0 < 1
    check(SLT , -32'sd1, 32'd1, 32'h1, "SLT");                   // -1 < 1 (signed)
    check(SLT , 32'd1, -32'sd1, 32'h0, "SLT");                   // 1 < -1 is false
    check(SLT , 32'd5, 32'd5, 32'h0, "SLT");                     // equal -> 0
    check(SLT , 32'h8000_0000, 32'h7FFF_FFFF, 32'h1, "SLT");     // INT_MIN < INT_MAX

    check(4'b1111, 32'h1, 32'h1, 32'h0, "DFLT");                 // unused code -> 0

    $display("%0d passed, %0d failed", pass_count, fail_count);
    $finish;
end

endmodule