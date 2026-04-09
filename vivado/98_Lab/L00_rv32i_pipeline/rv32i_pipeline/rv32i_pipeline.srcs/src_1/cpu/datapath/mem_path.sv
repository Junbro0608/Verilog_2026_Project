`timescale 1ns / 1ps

module mem_path (
    input               i_clk,
    input               i_rst,
    //INPUT
    input        [31:0] i_ex_alu_result,
    input        [31:0] i_dmem_rdata,
    input        [31:0] i_ex_imm,
    input        [31:0] i_ex_pc_plus_imm,
    input        [31:0] i_ex_pc_plus_4,
    //OUTPUT
    output logic [31:0] o_mem_alu_result,
    output logic [31:0] o_mem_dmem_rdata,
    output logic [31:0] o_mem_imm,
    output logic [31:0] o_mem_pc_plus_imm,
    output logic [31:0] o_mem_pc_plus_4
);

    always_ff @(posedge i_clk or posedge i_rst) begin : mem_path_ff
        if (i_rst) begin
            o_mem_alu_result  <= 0;
            o_mem_dmem_rdata  <= 0;
            o_mem_imm         <= 0;
            o_mem_pc_plus_imm <= 0;
            o_mem_pc_plus_4   <= 0;
        end else begin
            o_mem_alu_result  <= i_ex_alu_result;
            o_mem_dmem_rdata  <= i_dmem_rdata;
            o_mem_imm         <= i_ex_imm;
            o_mem_pc_plus_imm <= i_ex_pc_plus_imm;
            o_mem_pc_plus_4   <= i_ex_pc_plus_4;
        end
    end

endmodule
