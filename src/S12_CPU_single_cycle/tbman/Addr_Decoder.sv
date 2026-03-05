module Addr_Decoder(
    input [31:0] Addr,
    output reg CS_DMEM_N,
    output reg CS_TBMAN_N
);

always@(*)
    if (Addr[31:28] == 4'h1)
        cs_dmem_n = 1'b0;
        cs_tbman_n = 1'b1;
    else if (Addr[31:12] == 20'h8000F)
        cs_dmem_n = 1'b1;
        cs_tbman_n = 1'b0;
    else
        cs_dmem_n = 1'b1;
        cs_tbman_n = 1'b1;


endmodule