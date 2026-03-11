`timescale 1ns / 1ps
`include "../../src_1/rv32i_opcode.svh"


module tb_rv32i_s_type ();

    logic clk, rst;

    logic [4:0] rs1, rs2, shift_addr, rd;
    logic [31:0] rd1, rd2, shift;
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
            `DMEM.dmem[i] = 32'hffff_ffff;
        end
    endtask

    initial begin
        $timeformat(-9, 0, "ns");

        clk = 0;
        rst = 1;
        $display("[Test S_type Instr]");

        reset();

        `REG_FILE.reg_file[31] = 32'h11;
        `REG_FILE.reg_file[30] = 32'h22;
        `REG_FILE.reg_file[29] = 32'h33;
        `REG_FILE.reg_file[28] = 32'h44;
        
        

        //PC
        //dmem[rs1+imm] <= rs2[Byte,half,word] : {imm[6:0], rs2[4:0], rs1[4:0], funct3[2:0], imm[4:0],`S_TYPE}
        `INSTR_MEM.rom[0] =     {`FNC7_0,   5'd31,   5'h0,   `FNC3_SB,   5'h0,   `S_TYPE};  //SB dmem[0+0] <= x31
        `INSTR_MEM.rom[1] =     {`FNC7_0,   5'd30,   5'h0,   `FNC3_SB,   5'h1,   `S_TYPE};  //SB dmem[0+1] <= x30
        `INSTR_MEM.rom[2] =     {`FNC7_0,   5'd29,   5'h0,   `FNC3_SB,   5'h2,   `S_TYPE};  //SB dmem[0+2] <= x29
        `INSTR_MEM.rom[3] =     {`FNC7_0,   5'd28,   5'h0,   `FNC3_SB,   5'h3,   `S_TYPE};  //SB dmem[0+3] <= x28
        `INSTR_MEM.rom[4] =     {`FNC7_0,   5'd31,   5'h4,   `FNC3_SH,   5'h0,   `S_TYPE};  //SH dmem[4+0] <= x31
        `INSTR_MEM.rom[5] =     {`FNC7_0,   5'd30,   5'h4,   `FNC3_SH,   5'h1,   `S_TYPE};  //SH dmem[4+1] <= x30
        `INSTR_MEM.rom[6] =     {`FNC7_0,   5'd29,   5'h4,   `FNC3_SH,   5'h2,   `S_TYPE};  //SH dmem[4+2] <= x29
        `INSTR_MEM.rom[7] =     {`FNC7_0,   5'd28,   5'h4,   `FNC3_SH,   5'h3,   `S_TYPE};  //SH dmem[4+3] <= x28
        `INSTR_MEM.rom[8] =     {`FNC7_0,   5'd31,   5'h8,   `FNC3_SW,   5'h0,   `S_TYPE};  //SW dmem[8+0] <= x31
        `INSTR_MEM.rom[9] =     {`FNC7_0,   5'd30,   5'h8,   `FNC3_SW,   5'h1,   `S_TYPE};  //SW dmem[8+1] <= x30
        `INSTR_MEM.rom[10] =    {`FNC7_0,   5'd29,   5'h8,   `FNC3_SW,   5'h2,   `S_TYPE};  //SW dmem[8+2] <= x29
        `INSTR_MEM.rom[11] =    {`FNC7_0,   5'd28,   5'h8,   `FNC3_SW,   5'h3,   `S_TYPE};  //SW dmem[8+3] <= x28


        @(negedge clk);
        @(negedge clk);
        rst = 0;
        @(negedge clk);

        repeat (15) @(posedge clk);

        $stop;


    end
endmodule
