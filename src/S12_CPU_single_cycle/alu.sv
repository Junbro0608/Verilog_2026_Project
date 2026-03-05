module alu(
    a_in,
    b_in,
    ALUControl,
    result,
    aN,
    aZ,
    aC,
    aV
);
    input [31:0] a_in, b_in;
    input [3:0] ALUControl;
    output reg [31:0] result; 
    output reg aN, aZ, aC, aV;

    wire N, Z, C, V;
    wire [31:0] add_sub_b;
    wire [31:0] adder_result, and_result, or_result, SLT_result, xor_result, SLL_result, SRL_result, SLTU_result;     
    wire signed [31:0] sra_result;                                  
    
    wire signed [31:0] signed_a_in;
    assign signed_a_in = a_in;

    assign add_sub_b = (ALUControl == 4'b0001 || ALUControl == 4'b0101) ? ~b_in + 32'h1 : b_in;

    adder u_add_32bit_add(
        .a(a_in),
        .b(add_sub_b),
        .ci(1'b0),
        .sum(adder_result),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V)
    );    
    
    always@(*)begin
        if (ALUControl == 4'b0000 || ALUControl == 4'b0001 || ALUControl == 4'b1101) begin  //ADD,SUB,SLT
            {aN, aZ, aC, aV} = {N, Z, C, V};
        end
        else if (ALUControl == 4'b0010) begin                                               //AND
            aN = and_result[31];
            aZ = (and_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end
        else if (ALUControl == 4'b0011) begin                                               //OR
            aN = or_result[31];
            aZ = (or_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end
        else if (ALUControl == 4'b0100) begin                                               //XOR
        aN = xor_result[31];
        aZ = (xor_result == 32'h0) ? 1'b1 : 1'b0;
        aC = 1'b0;
        aV = 1'b0;
        end
        else if (ALUControl == 4'b0101) begin                                               // SLTU
        aN = xor_result[31];
        aZ = (xor_result == 32'h0) ? 1'b1 : 1'b0;
        aC = 1'b0;
        aV = 1'b0;
        end
        else begin
            {aN, aZ, aC, aV} = 4'h0;	
        end
    end

    assign and_result = a_in & b_in;
    assign or_result = a_in | b_in;
    assign xor_result = a_in^b_in;
    assign SLTU_result = {aC== 1'b0? 32'h1 : 32'h0};
    assign SLL_result = a_in << b_in[4:0]; 
    assign SRL_result = a_in >> b_in[4:0];  
    assign SLT_result = aN ^ aV;
    assign SRA_result = signed_a_in >>> b_in[4:0];

    always@(*) begin
        case(ALUControl)
            4'b0000 : result = adder_result;        // add
            4'b0001 : result = adder_result;        // sub
            4'b0010 : result = and_result;          // and
            4'b0011 : result = or_result;           // or
            4'b0100 : result = xor_result;          // xor
            4'b0101 : result = SLTU_result;         // SLTU
            4'b0110 : result = SLL_result;          // SLL
            4'b0111 : result = SRL_result;          // SRL
            4'b1101 : result = SLT_result;          // SLT
            4'b1111 : result = SRA_result;          // SRA
            default : result = 32'hx;
        endcase
    end

endmodule