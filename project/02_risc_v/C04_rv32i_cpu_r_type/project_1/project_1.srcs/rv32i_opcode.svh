// List of RISC-V opcodes, funct and define codes.
//

//typedef enum(Wave_foam for easy viewing)  : opcode, alu_control
//define(macro)                             : opcode, funct3, funct7

`ifndef rv32i_opcode
`define rv32i_opcode 


//opcode
`define R_TYPE 7'b011_0011

typedef enum logic [6:0] {R_type = `R_TYPE} opcode_t;
//--------------------R_type----------------------------
//funct3
`define FNC3_ADD_SUB 3'h0 
`define FNC3_SLL 3'h1 
`define FNC3_SLT 3'h2 
`define FNC3_SLTU 3'h3 
`define FNC3_XOR 3'h4 
`define FNC3_SRL_SRA 3'h5 
`define FNC3_OR 3'h6 
`define FNC3_AND 3'h7

`define FNC7_0 7'b0
`define FNC7_SUB 7'b010_0000 
`define FNC7_SRA 7'b010_0000

// alu_control
typedef enum logic [3:0] {
    ADD = 4'h0,
    SUB = 4'h1,
    SLL = 4'h2,
    SLT = 4'h3,
    SLTU = 4'h4,
    XOR = 4'h5,
    SRL = 4'h6,
    SRA = 4'h7,
    OR = 4'h8,
    AND = 4'h9,
    ALU_OFF = 4'hf
} alu_control_t;

`endif  //rv32i_opcode
