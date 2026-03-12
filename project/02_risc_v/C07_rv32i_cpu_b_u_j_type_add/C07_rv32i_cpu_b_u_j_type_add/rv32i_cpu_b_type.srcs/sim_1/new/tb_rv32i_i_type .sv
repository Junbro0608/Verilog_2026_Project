`timescale 1ns / 1ps
`include "../../src_1/rv32i_opcode.svh"


module tb_rv32i_i_type ();

    logic clk, rst;

    logic [4:0] rs1, rs2, shift_addr, rd;
    logic [31:0] rd1, rd2, shift;
    logic [31:0] imm;
    logic [31:0] sim_result;

    integer i;

    rv32I_top U_DUT (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    task reset();
        clk = 0;
        rst = 1;
        //REG
        for (i = 0; i < 32; i = i + 1) begin
            `REG_FILE.reg_file[i] = i;
        end
        //DMEM
        for (i = 1; i <32; i = i + 1) begin
            `DMEM.dmem[i] = 0;
        end
    endtask


    initial begin
        $timeformat(-9, 0, "ns");

        clk = 0;
        rst = 1;
        $display("[Test IL_type Instr]");

        reset();
        `REG_FILE.reg_file[1] = -100;
        imm = 200;


        //PC
        //rd <= ALU (rs1,imm) other : {imm[11:0], rs1[4:0],   funct3[2:0],    rd[4:0],    `I_TYPE}
        //rd <= ALU (rs1,imm) SLLI,SRLI,SRAI: {`FNC7_?? , shamt,  rs1[4:0],   funct3[2:0],    rd[4:0],    `I_TYPE}
        `INSTR_MEM.rom[0] = {imm,               5'h1,   `FNC3_ADD_SUB,  5'h2,   `I_TYPE};    //ADDI x2 = x1 + imm
        `INSTR_MEM.rom[1] = {imm,               5'h1,   `FNC3_SLT,      5'h2,   `I_TYPE};    //SLTI x2 = x1 + imm
        `INSTR_MEM.rom[2] = {imm,               5'h1,   `FNC3_SLTU,     5'h2,   `I_TYPE};    //SLTIU x2 = x1 + imm
        `INSTR_MEM.rom[3] = {imm,               5'h1,   `FNC3_XOR,      5'h2,   `I_TYPE};    //XORI x2 = x1 + imm
        `INSTR_MEM.rom[4] = {imm,               5'h1,   `FNC3_OR,       5'h2,   `I_TYPE};    //ORI x2 = x1 + imm
        `INSTR_MEM.rom[5] = {imm,               5'h1,   `FNC3_AND,      5'h2,   `I_TYPE};    //ANDI x2 = x1 + imm
        `INSTR_MEM.rom[6] = {`FNC7_0,   5'h2,   5'h1,   `FNC3_SLL,      5'h2,   `I_TYPE};    //SLLI x2 = x1 + imm
        `INSTR_MEM.rom[7] = {`FNC7_0,   5'h2,   5'h1,   `FNC3_SRL_SRA,  5'h2,   `I_TYPE};    //SRLI x2 = x1 + imm
        `INSTR_MEM.rom[8] = {`FNC7_SRA, 5'h2,   5'h1,   `FNC3_SRL_SRA,  5'h2,   `I_TYPE};    //SRAI x2 = x1 + imm

        @(negedge clk);
        @(negedge clk);
        rst = 0;
        @(negedge clk);

        repeat (10) @(posedge clk);

        $stop;


    end
endmodule
