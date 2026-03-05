module controller( //maindecoder
    opcode,
    funct3,
    funct7,
    PCSrc,
    ResultSrc,
    MemWrite,
    ALUSrcB,
    ALUSrcA, 
    ImmSrc,
    RegWrite,
    ALUControl,
    Jump,
    Branch,
    aN,
    aC,
    aV,
    Csr
);
    // input
    input aN, aZ, aC, aV
    input [6:0] opcode;
    input [2:0] funct3;
    input funct7;
    // output
    output [1:0] PCSrc;
    output MemWrite, RegWrite, Jump;
    output ALUSrcB;
    output [1:0] ALUSrcA;
    output [1:0] ResultSrc;
    output [2:0] ImmSrc;
    output [3:0] ALUControl;

    output Csr;
    output Branch;
    
    wire Btaken;
    wire [1:0] ALUop;

    maindec mdec(
        .opcode(opcode),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ALUop(ALUop),
        .Branch(Branch),
        .Btaken(Btaken),
        .Csr(Csr)
    );
    
    aludec adec(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUop(ALUop),
        .ALUControl(ALUControl)
    );

    b_type u_b_type(
    .Btaken(Btaken),
    .Branch(Branch),
    .funct3(funct3),
    .aZ(aZ),
    .aN(aN),
    .aC(aC),
    .aV(aV)
    );

endmodule
