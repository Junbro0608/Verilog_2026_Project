module maindec(
    opcode,
    PCSrc,
    ResultSrc,
    MemWrite,
    ALUSrcA,
    ALUSrcB,
    ImmSrc,
    RegWrite,
    Jump,
    ALUop,
    Btaken,
    Branch,
    Csr
);

    // input
    input Btaken;
    input [6:0] opcode;
    // output
    output reg [1:0] PCSrc;
    output reg MemWrite, RegWrite, Jump;
    output reg [1:0] ALUSrcA;
    output reg ALUSrcB;
    output reg [1:0] ResultSrc; 
    output reg [2:0] ImmSrc;
    output reg [1:0] ALUop;
    output reg Branch;
    output Csr; 


    always @(*) begin
        if(Btaken == 1'b1) begin
            PCSrc = 2'b01;
        end
        else if(Jump == 1'b1) begin
            PCSrc = 2'b01;
        end
        else if(opcode == 7'b110_0111) begin
            PCSrc = 2'b10;
        end
        else begin
            PCSrc = 2'b00;
        end
    end

    assign Csr = (opcode == 7'b111_0011)? 1: 0;

    always@(*) begin    // main decoder
        case(opcode)
            7'b011_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_xxx_00_0_0_00_0_10_0;     // R-type
            7'b110_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b0_010_00_0_0_00_1_01_0;     // B-type
            7'b001_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_000_00_1_0_00_0_10_0;     // I-type
            7'b000_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_000_00_1_0_01_0_00_0;	   // lw
            7'b110_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_000_00_1_0_10_0_10_0;     // JALR(I-type)
            7'b010_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b0_001_00_1_1_00_0_00_0;     // sw
            7'b011_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_100_10_1_0_00_x_00_0;     // LUI(U-type)
            7'b001_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_100_01_1_0_00_0_00_0;     // AUIPC(U-type)
            7'b110_1111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_011_00_0_0_10_0_01_1;     // J-type(jal)
            7'b111_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_101_00_1_0_00_0_10_0;     // csr
            default : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'hx;
        endcase
    end

endmodule
