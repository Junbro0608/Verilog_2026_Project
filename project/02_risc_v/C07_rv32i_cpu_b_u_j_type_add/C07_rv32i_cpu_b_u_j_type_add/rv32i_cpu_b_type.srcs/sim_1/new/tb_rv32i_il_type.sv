`timescale 1ns / 1ps
`include "../../src_1/rv32i_opcode.svh"


module tb_rv32i_il_type ();

    logic clk, rst;

    logic [4:0] rs1, rs2, shift_addr, rd;
    logic [31:0] rd1, rd2, shift;

    logic [31:0] sim_result;

    integer i;

    rv32I_top U_DUT (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    task reset();
        //REG
        for (i = 1; i < 32; i = i + 1) begin
            `REG_FILE.reg_file[i] = i;
        end
        //DMEM
        for (i = 0; i < 32; i = i + 1) begin
            `DMEM.dmem[i] = 32'hx;
        end
    endtask

    initial begin
        $timeformat(-9, 0, "ns");

        clk = 0;
        rst = 1;
        $display("[Test IL_type Instr]");
        reset();

        `DMEM.dmem[0] = 32'h04_f3_f2_01;


        //PC
        //rd <= rs+imm : {imm[11:0], rs1[4:0],   funct3[2:0],    rd[4:0],    `IL_TYPE}
        `INSTR_MEM.rom[0]  = {12'h0, 5'h0, `FNC3_LB,  5'h5, `IL_TYPE};    //LB  x5 = dmem[0+0]
        `INSTR_MEM.rom[1]  = {12'h1, 5'h0, `FNC3_LB,  5'h5, `IL_TYPE};    //LB  x5 = dmem[0+1]
        `INSTR_MEM.rom[2]  = {12'h2, 5'h0, `FNC3_LB,  5'h5, `IL_TYPE};    //LB  x5 = dmem[0+2]
        `INSTR_MEM.rom[3]  = {12'h3, 5'h0, `FNC3_LB,  5'h5, `IL_TYPE};    //LB  x5 = dmem[0+3]
        `INSTR_MEM.rom[4]  = {12'h0, 5'h0, `FNC3_LH,  5'h5, `IL_TYPE};    //LH  x5 = dmem[0+0]
        `INSTR_MEM.rom[5]  = {12'h1, 5'h0, `FNC3_LH,  5'h5, `IL_TYPE};    //LH  x5 = dmem[0+1]
        `INSTR_MEM.rom[6]  = {12'h2, 5'h0, `FNC3_LH,  5'h5, `IL_TYPE};    //LH  x5 = dmem[0+2]
        `INSTR_MEM.rom[7]  = {12'h3, 5'h0, `FNC3_LH,  5'h5, `IL_TYPE};    //LH  x5 = dmem[0+3]
        `INSTR_MEM.rom[8]  = {12'h0, 5'h0, `FNC3_LW,  5'h5, `IL_TYPE};    //LW  x5 = dmem[0+0]
        `INSTR_MEM.rom[9]  = {12'h1, 5'h0, `FNC3_LW,  5'h5, `IL_TYPE};    //LW  x5 = dmem[0+1]
        `INSTR_MEM.rom[10] = {12'h2, 5'h0, `FNC3_LW,  5'h5, `IL_TYPE};    //LW  x5 = dmem[0+2]
        `INSTR_MEM.rom[11] = {12'h3, 5'h0, `FNC3_LW,  5'h5, `IL_TYPE};    //LW  x5 = dmem[0+3]
        `INSTR_MEM.rom[12] = {12'h0, 5'h0, `FNC3_LBU, 5'h5, `IL_TYPE};    //LBU x5 = dmem[0+0]
        `INSTR_MEM.rom[13] = {12'h1, 5'h0, `FNC3_LBU, 5'h5, `IL_TYPE};    //LBU x5 = dmem[0+1]
        `INSTR_MEM.rom[14] = {12'h2, 5'h0, `FNC3_LBU, 5'h5, `IL_TYPE};    //LBU x5 = dmem[0+2]
        `INSTR_MEM.rom[15] = {12'h3, 5'h0, `FNC3_LBU, 5'h5, `IL_TYPE};    //LBU x5 = dmem[0+3]
        `INSTR_MEM.rom[16] = {12'h0, 5'h0, `FNC3_LHU, 5'h5, `IL_TYPE};    //LHU x5 = dmem[0+0]
        `INSTR_MEM.rom[17] = {12'h1, 5'h0, `FNC3_LHU, 5'h5, `IL_TYPE};    //LHU x5 = dmem[0+2]
        `INSTR_MEM.rom[18] = {12'h2, 5'h0, `FNC3_LHU, 5'h5, `IL_TYPE};    //LHU x5 = dmem[0+1]
        `INSTR_MEM.rom[19] = {12'h3, 5'h0, `FNC3_LHU, 5'h5, `IL_TYPE};    //LHU x5 = dmem[0+3]

        @(negedge clk);
        @(negedge clk);
        rst = 0;
        @(negedge clk);

        repeat (25) @(posedge clk);

        $stop;


    end
endmodule
