`timescale 1ns / 1ps

module rv32I_top (
    input clk,
    input rst
);
    logic [31:0] instr_addr, instr_data;

    instruction_mem U_INSTR_MEM (
        .instr_addr(instr_addr[31:2]),
        .instr_data(instr_data)
    );

    rv32i_cpu U_CPU (.*);


endmodule
