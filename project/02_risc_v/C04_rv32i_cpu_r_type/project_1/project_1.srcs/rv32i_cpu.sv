`timescale 1ns / 1ps
`include "rv32i_opcode.svh"

module rv32i_cpu (
    input         clk,
    input         rst,
    input  [31:0] instr_data,
    output [31:0] instr_addr
);
    logic rf_we;
    alu_control_t alu_control;

    logic [31:0] rd1, rd2, alu_result;
    logic [31:0] next_pc;

    register_file U_REG_FILE (
        .clk  (clk),
        .rst  (rst),
        .rf_we(rf_we),
        //write
        .wa   (instr_data[11:7]),
        .wd   (alu_result),
        //read
        .ra1  (instr_data[19:15]),
        .ra2  (instr_data[24:20]),
        .rd1  (rd1),
        .rd2  (rd2)
    );

    control_unit U_CTRL_UNIT (
        .clk(clk),
        .rst(rst),
        .funct7(instr_data[31:25]),
        .funct3(instr_data[14:12]),
        .opcode(opcode_t'(instr_data[6:0])),
        .rf_we(rf_we),
        .alu_control(alu_control)
    );

    alu U_ALU (
        .rd1        (rd1),
        .rd2        (rd2),
        .alu_control(alu_control),
        .alu_result (alu_result)
    );

    pc U_PC (
        .clk (clk),
        .rst (rst),
        .i_pc(instr_addr + 4),
        .o_pc(instr_addr)
    );
endmodule


module register_file #(
    parameter ADDR = 32,
    BIT_WIDTH = 32
) (
    input                     clk,
    input                     rst,
    input                     rf_we,
    //write
    input  [$clog2(ADDR)-1:0] wa,
    input  [ BIT_WIDTH - 1:0] wd,
    //read
    input  [$clog2(ADDR)-1:0] ra1,
    input  [$clog2(ADDR)-1:0] ra2,
    output [ BIT_WIDTH - 1:0] rd1,
    output [ BIT_WIDTH - 1:0] rd2
);

    logic [BIT_WIDTH - 1:0] mem[0:ADDR-1];

    assign rd1 = mem[ra1];
    assign rd2 = mem[ra2];

    initial begin
        mem[0] = 0;
    end


    always_ff @(posedge clk or posedge rst) begin : reg_ff
        if (rst) begin
        end else begin
            if (rf_we) begin
                mem[wa] = wd;
            end
        end
    end
endmodule


module control_unit (
    input                      clk,
    input                      rst,
    input                [6:0] funct7,
    input                [2:0] funct3,
    input  opcode_t            opcode,
    output logic               rf_we,
    output alu_control_t       alu_control
);

    always_comb begin : cmd_comb
        rf_we = 0;
        alu_control = ALU_OFF;
        case (opcode)
            R_type: begin
                rf_we = 1;
                case (funct3)
                    `FNC3_ADD_SUB: alu_control = (funct7[5] == 0) ? ADD : SUB;
                    `FNC3_SLL:     alu_control = SLL;
                    `FNC3_SLT:     alu_control = SLT;
                    `FNC3_SLTU:    alu_control = SLTU;
                    `FNC3_XOR:     alu_control = XOR;
                    `FNC3_SRL_SRA: alu_control = (funct7[5] == 0) ? SRL : SRA;
                    `FNC3_OR:      alu_control = OR;
                    `FNC3_AND:     alu_control = AND;
                endcase
            end
        endcase
    end
endmodule

module alu (
    input                [31:0] rd1,
    input                [31:0] rd2,
    input  alu_control_t        alu_control,
    output logic         [31:0] alu_result
);

    always_comb begin : alu_comb
        alu_result = 0;
        case (alu_control)
            ADD:  alu_result = rd1 + rd2;
            SUB:  alu_result = rd1 - rd2;
            SLL:  alu_result = rd1 << rd2;
            SLT:  alu_result = ($signed(rd1) < $signed(rd2)) ? 32'b1 : 32'b0;
            SLTU: alu_result = (rd1 < rd2) ? 32'b1 : 32'b0;
            XOR:  alu_result = rd1 ^ rd2;
            SRL:  alu_result = rd1 >> rd2;
            SRA:  alu_result = $signed(rd1) >>> rd2;
            OR:   alu_result = rd1 | rd2;
            AND:  alu_result = rd1 & rd2;
        endcase
    end

endmodule


module pc (
    input               clk,
    input               rst,
    input        [31:0] i_pc,
    output logic [31:0] o_pc
);



    always_ff @(posedge clk or posedge rst) begin : pc_ff
        if (rst) begin
            o_pc <= 0;
        end else begin
            o_pc <= i_pc;
        end
    end

endmodule
