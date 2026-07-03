`timescale 1ns / 1ps


module VGA_RGB_SW (
    input  logic [3:0] sw_red,
    input  logic [3:0] sw_green,
    input  logic [3:0] sw_blue,
    input  logic       de,
    output logic [3:0] port_red,
    output logic [3:0] port_green,
    output logic [3:0] port_blue
);

    always_comb begin
        if (de) begin
            port_red   = sw_red;
            port_green = sw_green;
            port_blue  = sw_blue;
        end else begin
            port_red   = 0;
            port_green = 0;
            port_blue  = 0;
        end
    end

endmodule
