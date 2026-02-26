`timescale 1ns / 1ps

module register #(
    parameter BIT_WIDTH = 8
) (
    input                        clk,
    input                        rst,
    input  logic                 we,
    input  logic [BIT_WIDTH-1:0] wdata,
    output logic [BIT_WIDTH-1:0] rdata
);

    always_ff @(posedge clk or posedge rst) begin : register
        if (rst) begin
            rdata <= 0;
        end else begin
            if (we) begin
                rdata <= wdata;
            end
        end
    end

endmodule
