`timescale 1ns / 1ps


module VGA_img_rom_reader (
    input  logic                       de,
    input  logic                       resize_en,
    input  logic [                9:0] x_pixel,
    input  logic [                9:0] y_pixel,
    output logic [$clog2(320*240)-1:0] addr,
    input  logic [               15:0] imgPXlData,
    output logic [                3:0] port_red,
    output logic [                3:0] port_green,
    output logic [                3:0] port_blue
);

    always_comb begin
        addr = 0;
        if (de) begin
            if (resize_en) begin
                addr = (y_pixel >> 1) * 320 + (x_pixel >> 1);
            end else begin
                if (x_pixel < 320 && y_pixel < 240) addr = y_pixel * 320 + x_pixel;
            end
        end
    end

    assign port_red   = imgPXlData[15:12];
    assign port_green = imgPXlData[10:7];
    assign port_blue  = imgPXlData[4:1];


endmodule