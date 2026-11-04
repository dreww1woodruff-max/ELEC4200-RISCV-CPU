# Instruction Set

## Ground rules
- 32-bit fixed-width instructions
- 32 registers, x0 to x31 (x0 is hardwired to zero)
- Standard RV32I encodings
- Byte-addressed, little-endian memory
- All immediates are sign-extended from instruction bit 31

## Instruction formats

| Type | 31:25 | 24:20 | 19:15 | 14:12 | 11:7 | 6:0 |
|---|---|---|---|---|---|---|
| **R** | funct7 | rs2 | rs1 | funct3 | rd | opcode |
| **I** | imm[11:5] | imm[4:0] | rs1 | funct3 | rd | opcode |
| **S** | imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode |

### J-type

| 31 | 30:21 | 20 | 19:12 | 11:7 | 6:0 |
|---|---|---|---|---|---|
| imm[20] | imm[10:1] | imm[11] | imm[19:12] | rd | opcode |

imm[0] is implicitly 0.

## Instruction table

| Instr | Type | opcode | funct3 | funct7 | Operation |
|---|---|---|---|---|---|
| ADD | R | 0110011 | 000 | 0000000 | rd = rs1 + rs2 |
| SUB | R | 0110011 | 000 | 0100000 | rd = rs1 - rs2 |
| AND | R | 0110011 | 111 | 0000000 | rd = rs1 & rs2 |
| OR | R | 0110011 | 110 | 0000000 | rd = rs1 \| rs2 |
| XOR | R | 0110011 | 100 | 0000000 | rd = rs1 ^ rs2 |
| SLT | R | 0110011 | 010 | 0000000 | rd = (rs1 < rs2 signed) ? 1 : 0 |
| ADDI | I | 0010011 | 000 | n/a | rd = rs1 + imm |
| ANDI | I | 0010011 | 111 | n/a | rd = rs1 & imm |
| ORI | I | 0010011 | 110 | n/a | rd = rs1 \| imm |
| LW | I | 0000011 | 010 | n/a | rd = mem[rs1 + imm] |
| SW | S | 0100011 | 010 | n/a | mem[rs1 + imm] = rs2 |
| JAL | J | 1101111 | n/a | n/a | rd = PC + 4; PC = PC + imm |
| JALR | I | 1100111 | 000 | n/a | rd = PC + 4; PC = (rs1 + imm) & ~1 |

## Worked examples

### R-type: `add x7, x5, x6`

rd = x7, rs1 = x5, rs2 = x6

| funct7 | rs2 | rs1 | funct3 | rd | opcode |
|---|---|---|---|---|---|
| 0000000 | 00110 | 00101 | 000 | 00111 | 0110011 |

Binary: `0000 0000 0110 0010 1000 0011 1011 0011` = `0x006283B3`

### I-type: `addi x5, x0, 10`

rd = x5, rs1 = x0, imm = 10

| imm[11:0] | rs1 | funct3 | rd | opcode |
|---|---|---|---|---|
| 000000001010 | 00000 | 000 | 00101 | 0010011 |

Binary: `0000 0000 1010 0000 0000 0010 1001 0011` = `0x00A00293`

### S-type: `sw x6, 8(x5)`

Stores x6 to address x5 + 8. The immediate 8 = `000000001000` is split across two fields.

| imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode |
|---|---|---|---|---|---|
| 0000000 | 00110 | 00101 | 010 | 01000 | 0100011 |

Binary: `0000 0000 0110 0010 1010 0100 0010 0011` = `0x0062A423`

### J-type: `jal x1, 2052`

Jumps to PC + 2052 and saves PC + 4 in x1. The offset 2052 = `0x804`, which as a 21-bit immediate imm[20:0] is `0 0000 0000 1000 0000 0100`, so imm[11] and imm[2] are set. It was chosen to exercise the scrambled layout.

| imm bit(s) | Value | Lands in instruction bits |
|---|---|---|
| imm[20] | 0 | 31 |
| imm[10:1] | 0000000010 | 30:21 |
| imm[11] | 1 | 20 |
| imm[19:12] | 00000000 | 19:12 |

| imm[20] | imm[10:1] | imm[11] | imm[19:12] | rd | opcode |
|---|---|---|---|---|---|
| 0 | 0000000010 | 1 | 00000000 | 00001 | 1101111 |

Binary: `0000 0000 0101 0000 0000 0000 1110 1111` = `0x005000EF`
