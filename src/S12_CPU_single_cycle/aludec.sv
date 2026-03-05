module aludec(
    opcode,
    funct3,
    funct7,
    ALUop,
    ALUControl
);
// input
input [6:0] opcode;
input [2:0] funct3;
input [1:0] ALUop;
input funct7;
// output
output reg [3:0] ALUControl;

always@(*)begin                // ALU decoder
    if(ALUop == 2'b00)
        ALUControl = 4'b0000;                                                                                                   //lw, sw, sb, AUIPC, LUI
    else if(ALUop == 2'b01)
        ALUControl = 4'b0001;                                                                                                   //b-type
    else if (funct3 == 3'b011)
        ALUControl = 4'b0101;                                                                                                   // SLTU SLTIU

    else if(ALUop == 2'b10) begin
        if (funct3 == 3'b000 && ({opcode[5], funct7} == 2'b00 || {opcode[5], funct7} == 2'b01 || {opcode[5], funct7} == 2'b10)) //add
            ALUControl = 4'b0000;
        else if (funct3 == 3'b000 && {opcode[5], funct7} == 2'b11) begin													   
            if(opcode == 7'b1100111)
                ALUControl = 4'b0000;                                                                                           //jal
            else
                ALUControl = 4'b0001;                                                                                           //sub
        end
        else if (funct3 == 3'b010)																							    //SLT
            ALUControl = 4'b1101;
        else if (funct3 == 3'b110)																								//or
            ALUControl = 4'b0011;
        else if (funct3 == 3'b111)																							    //and
            ALUControl = 4'b0010;
        else if (funct3 == 3'b100)																							    //xor
            ALUControl = 4'b0100;
        else if (funct3 == 3'b001)	   										                                                    //SLL
            ALUControl = 4'b0110;
        else if (funct3 == 3'b101)begin
            if(funct7 == 1'b1)
                ALUControl = 4'b1110;                                                                                           //SRA
            else
                ALUControl = 4'b0111;                                                                                           //SRL
        end                                                                                       
        else 
            ALUControl = 3'hx;
    end
end

endmodule