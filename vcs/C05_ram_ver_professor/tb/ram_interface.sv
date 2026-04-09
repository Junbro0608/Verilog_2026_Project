`ifndef RAM_IF_SV
`define RAM_IF_SV

interface ram_if (
    input logic clk
);
    logic write;
    logic [7:0] addr;
    logic [15:0] wdata;
    logic [15:0] rdata;

    clocking drv_cb @(posedge clk);
        default input #1 output #0;
        output write;
        output addr;
        output wdata;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1;
        input write;
        input addr;
        input wdata;
        input rdata;
    endclocking
endinterface  //ram_if



`endif