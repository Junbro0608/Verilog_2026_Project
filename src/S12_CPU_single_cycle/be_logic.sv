module be_logic(
    adder_Last2,
    WD,
    RD,
    funct3,
    BE_WD,
    BE_RD,
    ByteEnable
);

input [1:0] adder_Last2; // sel
input [2:0] funct3; // sel
input [31:0] WD; 
input [31:0] RD;

output reg [31:0] BE_RD;
output reg [31:0] BE_WD;
output reg [3:0] ByteEnable;

always@(*)begin 
    if(funct3 == 3'b000) begin                  // LB,SB
        if(adder_Last2 == 2'b00)begin
            BE_RD = {{24{RD[7]}}, RD[7:0]};
            BE_WD = {24'b0, WD[7:0]};
            ByteEnable = 4'b0001;
        end
        else if(adder_Last2 == 2'b01)begin
            BE_WD = {16'b0, WD[7:0], 8'b0};
            BE_RD = {{24{RD[15]}}, RD[15:8]};
            ByteEnable = 4'b0010;
        end
        else if(adder_Last2 == 2'b10)begin
            BE_WD = {8'b0, WD[7:0], 16'b0};
            BE_RD = {{24{RD[23]}}, RD[23:16]};
            ByteEnable = 4'b0100;
        end
        else if(adder_Last2 == 2'b11)begin
            BE_WD = {WD[7:0], 24'b0};
            BE_RD = {{24{RD[31]}}, RD[31:24]};
            ByteEnable = 4'b1000;
        end
    end                    
    else if(funct3 == 3'b001)begin              // LH,SH
        if(adder_Last2 == 2'b00)begin
            BE_RD = {{16{RD[15]}}, RD[15:0]};
            BE_WD = {16'h0, WD[15:0]};
            ByteEnable = 4'b0011; 
        end
        else if(adder_Last2 == 2'b10)begin
            BE_RD = {{16{RD[31]}}, RD[31:16]};
            BE_WD = {WD[15:0], 16'h0};
            ByteEnable = 4'b1100;
        end
    end
    else if(funct3 == 3'b010)begin              // LW,SW
        BE_RD = RD;
        BE_WD = WD;
        ByteEnable = 4'b1111;
    end
    else if(funct3 == 3'b100)  begin            // LBU
        if(adder_Last2 == 2'b00)begin
            BE_RD = {24'b0, RD[7:0]};
        end
        else if(adder_Last2 == 2'b01)begin
            BE_RD = {24'b0, RD[15:8]};
        end
        else if(adder_Last2 == 2'b10)begin
            BE_RD = {24'b0, RD[23:16]};
        end
        else if(adder_Last2 == 2'b11)begin
            BE_RD = {24'b0, RD[31:24]};
        end
    end
    else if(funct3 == 3'b101) begin             // LHU
        if(adder_Last2 == 2'b00)begin
            BE_RD = {16'h0, RD[15:0]};
        end
        else if(adder_Last2 == 2'b10)begin
            BE_RD = {16'h0, RD[31:16]};
        end
    end
    else begin
            BE_RD = RD;
            BE_WD = WD;
            ByteEnable = 4'b1111;
    end
end


endmodule