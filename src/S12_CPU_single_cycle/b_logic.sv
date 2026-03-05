module b_type(
    Btaken,
    Branch,
    funct3,
    aN,
    aZ,
    aC,
    aV
);

input aN, aZ, aC, aV;
input [2:0] funct3;
input Branch;
output reg Btaken;

always @(*) 
    if (Branch == 1'b1) begin
        if (funct3 == 3'b000) begin         //beq   ==
            if(aZ == 1'b1)
                Btaken = 1'b1;
            else
                Btaken = 1'b0; 
        end
        else if(funct3 == 3'b001) begin     //bne   !=
            if(aZ == 1'b0) 
                Btaken = 1'b1;
            else
                Btaken = 1'b0; 
        end
        else if(funct3 == 3'b100) begin     //blt   <
            if(aN != aV) 
                Btaken = 1'b1;
            else
                Btaken = 1'b0; 
        end
        else if(funct3 == 3'b101) begin     //BGE   >=
            if(aN == aV)
                Btaken = 1'b1;
            else
                Btaken = 1'b0;
        end
        else if(funct3 == 3'b110) begin     //BLTU  <
            if(aC == 1'b0) 
                Btaken = 1'b1;
            else
                Btaken = 1'b0; 
        end
        else if(funct3 == 3'b111) begin     //BGEU  >=
            if(aC == 1'b1) 
                Btaken = 1'b1;
            else
                Btaken = 1'b0; 
        end
        else
            Btaken = 1'b0;
    end
    else begin
        Btaken = 1'b0;
    end

endmodule
