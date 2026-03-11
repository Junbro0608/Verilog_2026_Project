`timescale 1ns / 1ps
`include "../../src_1/rv32i_opcode.svh"


module tb_rv32i_u_j_type ();

    logic clk, rst;

    logic [4:0] rs1, rs2, shift_addr, rd;
    logic [31:0] rd1, rd2, shift;
    logic [12:0] off_set;  //B_type imm
    logic [20:0] imm_21; //U_type,JAL_type
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
        // `REG_FILE.reg_file[1] = -200;

        /*
        */
        //PC  
        //
        imm_21 = 21'd10;
        if (1) begin
        $display("%b",{imm_21[20],imm_21[10:1],imm_21[11],imm_21[19:12]});
        //LUI
        `INSTR_MEM.rom[0] = {32'd10, 5'd1, `LUI_TYPE};
        `INSTR_MEM.rom[1] = {-10, 5'd2, `LUI_TYPE};
        //AUIPC
        `INSTR_MEM.rom[2] = {10,5'd1,`AUIPC_TYPE};
        end
        if (1) begin
        //JAL
        `INSTR_MEM.rom[2] = {imm_21[20],imm_21[10:1],imm_21[11],imm_21[19:12],5'd3,`JAL_TYPE};
        // //JALR
        // `INSTR_MEM.rom[2] = {-100,5'd3,`JALR_TYPE};
        end


        start();

        repeat (17) @(posedge clk);

        $stop;


    end
endmodule
