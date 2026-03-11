`timescale 1ns / 1ps
`include "../../src_1/rv32i_opcode.svh"


module tb_rv32i_b_type ();

    logic clk, rst;

    logic [4:0] rs1, rs2, shift_addr, rd;
    logic [31:0] rd1, rd2, shift;
    logic [12:0] off_set;   //B_type imm
    integer i;

    logic [31:0] sim_result;

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
        for (i = 1; i < 32; i = i + 1) begin
            `DMEM.dmem[i] = 32'h0;
        end
    endtask

    task start();
        @(negedge clk);
        @(negedge clk);
        rst = 0;
        @(negedge clk);
    endtask

    initial begin
        $timeformat(-9, 0, "ns");

        clk = 0;
        rst = 1;
        $display("[Test S_type Instr]");

        reset();
        `REG_FILE.reg_file[1] = -200;
           
        /*
        -----all true case-----
        [0]  BEQ  if(x1 == x1)  PC += 4 * 4
        [4]  BNE  if(x0 != x1)  PC += 4 * 4
        [8]  BLT  if(x1 <  x0)  PC += 4 * 4
        [12] BGE  if(x1 <= x0)  PC += 4 * 4
        [16] BLTU if(x0 <= x1)  PC += 4 * 4
        [20] BGEU if(x0 <  x1)  PC += 4 * 4
        [24] ADD  x2 = x1 + x1
        -----all false case-----
        [25] BEQ  if(x0 == x1)  PC += 4 * 4
        [26] BNE  if(x1 != x1)  PC += 4 * 4
        [27] BLT  if(x0 <  x1)  PC += 4 * 4
        [28] BGE  if(x0 <= x1)  PC += 4 * 4
        [29] BLTU if(x1 <  x0)  PC += 4 * 4
        [30] BGEU if(x1 <= x0)  PC += 4 * 4
        [31] SUB  x2 = x1 - x2
        */
        //PC  
        //if(rs1 == rs2) PC += imm : {imm[12,10:5], rs2[4:0], rs1[4:0], funct3[2:0], imm[4:1,11],`B_TYPE}
        off_set = 2 * 4;
        `INSTR_MEM.rom[0]  = {off_set[12], off_set[10:5], 5'd1, 5'd1, `FNC3_BEQ,  off_set[4:1], off_set[11], `B_TYPE};
        `INSTR_MEM.rom[2]  = {off_set[12], off_set[10:5], 5'd1, 5'd0, `FNC3_BNE,  off_set[4:1], off_set[11], `B_TYPE}; 
        `INSTR_MEM.rom[4]  = {off_set[12], off_set[10:5], 5'd0, 5'd1, `FNC3_BLT,  off_set[4:1], off_set[11], `B_TYPE};
        `INSTR_MEM.rom[6]  = {off_set[12], off_set[10:5], 5'd0, 5'd1, `FNC3_BGE,  off_set[4:1], off_set[11], `B_TYPE}; 
        `INSTR_MEM.rom[8]  = {off_set[12], off_set[10:5], 5'd1, 5'd0, `FNC3_BLTU, off_set[4:1], off_set[11], `B_TYPE};  
        `INSTR_MEM.rom[10] = {off_set[12], off_set[10:5], 5'd1, 5'd0, `FNC3_BGEU, off_set[4:1], off_set[11], `B_TYPE}; 
        `INSTR_MEM.rom[12] = {`FNC7_0,                    5'd1, 5'd1, `FNC3_ADD_SUB,                   5'd2, `R_TYPE};

        `INSTR_MEM.rom[13] = {off_set[12], off_set[10:5], 5'd1, 5'd0, `FNC3_BEQ,  off_set[4:1], off_set[11], `B_TYPE};
        `INSTR_MEM.rom[14] = {off_set[12], off_set[10:5], 5'd1, 5'd1, `FNC3_BNE,  off_set[4:1], off_set[11], `B_TYPE}; 
        `INSTR_MEM.rom[15] = {off_set[12], off_set[10:5], 5'd1, 5'd0, `FNC3_BLT,  off_set[4:1], off_set[11], `B_TYPE};
        `INSTR_MEM.rom[16] = {off_set[12], off_set[10:5], 5'd1, 5'd0, `FNC3_BGE,  off_set[4:1], off_set[11], `B_TYPE}; 
        `INSTR_MEM.rom[17] = {off_set[12], off_set[10:5], 5'd0, 5'd1, `FNC3_BLTU, off_set[4:1], off_set[11], `B_TYPE}; 
        `INSTR_MEM.rom[18] = {off_set[12], off_set[10:5], 5'd0, 5'd1, `FNC3_BGEU, off_set[4:1], off_set[11], `B_TYPE};  
        `INSTR_MEM.rom[19] = {`FNC7_SUB,                  5'd2, 5'd1, `FNC3_ADD_SUB,                   5'd2, `R_TYPE};
        start();

        repeat (17) @(posedge clk);

        $stop;


    end
endmodule
