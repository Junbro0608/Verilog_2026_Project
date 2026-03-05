module datapath(
    clk,
    n_rst,
    Instr,         // from imem
    ReadData,      // from dmem
    PCSrc,         // from controller ......
    ResultSrc,
    ALUControl,
    ALUSrcB,
    ALUSrcA,
    ImmSrc,
    RegWrite,
    PC,            // for imem  
    ALUResult,     // for dmem ..
    WriteData,      
    aN,            // for controller
    aZ,       
    aC,
    aV,
    ByteEnable,
    Csr
);

    parameter   RESET_PC = 32'h1000_0000;

    //input
    input clk, n_rst, ALUSrcB, RegWrite;
    input [31:0] Instr, ReadData;
    input [1:0] ResultSrc, PCSrc;
    input [2:0] ImmSrc;
    input [3:0] ALUControl;
    input [1:0] ALUSrcA;
    input Csr;
    //output
    output [31:0] PC, ALUResult;
    output [31:0] WriteData;
    output aZ, aN, aC, aV;
    output [3:0] ByteEnable;
    
    wire [31:0] PC_next, PC_target, PC_plus4;
    wire [31:0] ImmExt;                       
    wire [31:0] bef_SrcA, bef_SrcB;
    wire [31:0] SrcB;
    wire [31:0] SrcA;
    wire [31:0] Result;
    wire [31:0] BE_RD;
    wire [31:0] BE_WD;
    wire [31:0] Mux3Result;

    assign WriteData = BE_WD;

    pc_mux u_pc_mux(
        .in0(PC_plus4),
        .in1(PC_target),
        .in2(ALUResult),
        .sel(PCSrc),
        .out(PC_next)
    );
    
    flopr # (
        .RESET_VALUE (RESET_PC)
    ) u_pc_register(
        .clk(clk),
        .n_rst(n_rst),
        .d(PC_next),
        .q(PC)
    );

    adder u_pc_plus4(
        .a(PC), 
        .b(32'h4), 
        .ci(1'b0), 
        .sum(PC_plus4),
        .N(),
        .Z(),
        .C(),
        .V()
    );

    extend u_Extend(
        .ImmSrc(ImmSrc),
        .in(Instr[31:7]),
        .out(ImmExt)
    );

    adder u_pc_target(
        .a(PC), 
        .b(ImmExt), 
        .ci(1'b0), 
        .sum(PC_target),
        .N(),
        .Z(),
        .C(),
        .V()
    );
    
    reg_file_async rf (
        .clk        (clk),
        .clkb       (clk),
        .we         (RegWrite),
        .ra1        (Instr[19:15]),
        .ra2        (Instr[24:20]),
        .wa         (Instr[11:7]),
        .wd         (Result),
        .rd1        (bef_SrcA),                      
        .rd2        (bef_SrcB)
    );

    mux3 u_mux3(
        .in0(bef_SrcA),
        .in1(PC),
        .in2(32'h0),
        .sel(ALUSrcA),
        .out(SrcA)
    );

    mux2 u_alu_mux2(
        .in0(bef_SrcB),
        .in1(ImmExt),
        .sel(ALUSrcB),
        .out(SrcB)
    );

    alu u_ALU(
        .a_in(SrcA),
        .b_in(SrcB),
        .ALUControl(ALUControl),
        .result(ALUResult),
        .aN(aN),
        .aZ(aZ),
        .aC(aC),
        .aV(aV)
    );

    be_logic u_be_logic(
        .adder_Last2(ALUResult[1:0]),
        .WD(bef_SrcB),
        .RD(ReadData),
        .funct3(Instr[14:12]),
        .BE_WD(WriteData),
        .BE_RD(BE_RD),
        .ByteEnable(ByteEnable)
    );

    mux3 u_result_mux3(
        .in0(ALUResult),
        .in1(BE_RD), // -> BE_RD
        .in2(PC_plus4),
        .sel(ResultSrc),
        .out(Mux3Result)
    );

    //Csr
    reg [31:0] tohost_csr;

    always @(*)
        if(Csr == 1'b1) begin
            case(Instr[14:12])
                3'b001 : tohost_csr = bef_SrcA;
                3'b101 : tohost_csr = ImmExt;
                default : tohost_csr = 32'h0;
            endcase
        end
        else
            tohost_csr = 32'h0;

    mux2 u_csr_mux2(
        .in0(Mux3Result),
        .in1(tohost_csr),
        .sel(csr),
        .out(Result)
    );
endmodule
