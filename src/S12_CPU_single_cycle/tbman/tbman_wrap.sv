module tbman_wrap(
    input clk,
    input rst_n,

    input tbman_sel,        //High Active
    input tbman_write,      //W:1,R:0
    input [15:0] tbman_addr,
    input [31:0] tbman_wdata,
    output [31:0] tbman_rdata
);

always @(posedge clk or negedge rst_n)
    if(rst_n)
        tbman_rdata
    else

endmodule