`timescale 1ns / 1ps

module ram (
    input               clk,
    input               write,
    input        [ 7:0] addr,
    input        [15:0] wdata,
    output logic [15:0] rdata
);

    logic [15:0] mem[0:2**8-1];

    always_ff @(posedge clk) begin : ram_ff
        if (write) begin
            mem[addr] <= wdata;
        end else begin
            rdata <= mem[addr];
        end
    end

endmodule
