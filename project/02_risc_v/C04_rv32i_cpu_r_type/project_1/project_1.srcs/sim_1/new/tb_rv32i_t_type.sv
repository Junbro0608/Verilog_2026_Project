`timescale 1ns / 1ps
`include "../../rv32i_opcode.svh"


module tb_rv32i_t_type ();

    logic clk, rst;

    logic [4:0] rs1,rs2, shift_addr,rd;
    logic [31:0] rd1, rd2, shift, rd;
 
    rv32I_top U_DUT (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        rs1 = 1; rd1 = -100;
        rs2 = 2; rd2 = 200;
        shift_addr = 3; shift = 2;
        rd = 4;
        $display("[Test R_type Instr]");
        //REG
        U_DUT.U_CPU.U_REG_FILE.mem[rs1] = rd1;
        U_DUT.U_CPU.U_REG_FILE.mem[rs2] = rd2;
        U_DUT.U_CPU.U_REG_FILE.mem[shift_addr] = shift;

        //PC
        U_DUT.U_INSTR_MEM.rom[0] = {`FNC7_0,   rs2,    rs1,    `FNC3_ADD_SUB,  rd, `R_TYPE};
        U_DUT.U_INSTR_MEM.rom[1] = {`FNC7_SUB, rs2,    rs1,    `FNC3_ADD_SUB,  rd, `R_TYPE};
        U_DUT.U_INSTR_MEM.rom[2] = {`FNC7_0,   shift_addr,    rs1,    `FNC3_SLL,      rd, `R_TYPE};
        U_DUT.U_INSTR_MEM.rom[3] = {`FNC7_0,   rs2,    rs1,    `FNC3_SLT,      rd, `R_TYPE};
        U_DUT.U_INSTR_MEM.rom[4] = {`FNC7_0,   rs2,    rs1,    `FNC3_SLTU,     rd, `R_TYPE};
        U_DUT.U_INSTR_MEM.rom[5] = {`FNC7_0,   rs2,    rs1,    `FNC3_XOR,      rd, `R_TYPE};
        U_DUT.U_INSTR_MEM.rom[6] = {`FNC7_0,   shift_addr,    rs1,    `FNC3_SRL_SRA,  rd, `R_TYPE};
        U_DUT.U_INSTR_MEM.rom[7] = {`FNC7_SRA, shift_addr,    rs1,    `FNC3_SRL_SRA,  rd, `R_TYPE};
        U_DUT.U_INSTR_MEM.rom[8] = {`FNC7_0,   rs2,    rs1,    `FNC3_OR,       rd, `R_TYPE};
        U_DUT.U_INSTR_MEM.rom[9] = {`FNC7_0,   rs2,    rs1,    `FNC3_AND,      rd, `R_TYPE};

        @(negedge clk);
        @(negedge clk);
        rst = 0;
        @(negedge clk);

        repeat(10) @(posedge clk);

        $stop;


    end
endmodule
