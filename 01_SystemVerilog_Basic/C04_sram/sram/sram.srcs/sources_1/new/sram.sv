`timescale 1ns / 1ps

module sram #(
    parameter DATA_ADDR = 16,
    parameter BIT_WIDTH = 8
) (
    input                                clk,
    input                                we,
    input        [$clog2(DATA_ADDR)-1:0] addr,
    input        [        BIT_WIDTH-1:0] wdata,
    output logic [        BIT_WIDTH-1:0] rdata
);

    logic [BIT_WIDTH-1:0] sram_reg[0:DATA_ADDR-1];

    always_ff @(posedge clk) begin : sram_wdata
        if (we) begin
            sram_reg[addr] <= wdata;
        end
    end

    assign rdata = sram_reg[addr];
endmodule
