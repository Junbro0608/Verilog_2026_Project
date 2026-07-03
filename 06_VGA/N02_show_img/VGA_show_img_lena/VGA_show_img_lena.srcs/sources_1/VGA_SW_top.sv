`timescale 1ns / 1ps


module VGA_SW_top (
    input  logic       clk,
    input  logic       reset,
    input  logic [3:0] sw_red,
    input  logic [3:0] sw_green,
    input  logic [3:0] sw_blue,
    input  logic [1:0] sw_mode,
    output logic       h_sync,
    output logic       v_sync,
    output logic [3:0] port_red,
    output logic [3:0] port_green,
    output logic [3:0] port_blue
);
    logic [9:0] x_pixel, y_pixel;
    logic                       de;
    logic [$clog2(320*240)-1:0] addr;
    logic [               15:0] imgPXlData;

    VGA_Decoder u_VGA_Decoder (
        .clk    (clk),
        .reset  (reset),
        .h_sync (h_sync),
        .v_sync (v_sync),
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .de     (de)
    );

    rgb_selector u_rgb_selector (
        .clk       (clk),
        .reset     (reset),
        .de        (de),
        .mode      (sw_mode),
        .sw_red    (sw_red),
        .sw_green  (sw_green),
        .sw_blue   (sw_blue),
        .x_pixel   (x_pixel),
        .y_pixel   (y_pixel),
        .addr      (addr),
        .imgPXlData(imgPXlData),
        .port_red  (port_red),
        .port_green(port_green),
        .port_blue (port_blue)
    );



    VGA_img_rom u_VGA_img_rom (
        .addr    (addr),
        .data_out(imgPXlData)
    );
endmodule



module rgb_selector (
    input  logic                       clk,
    input  logic                       reset,
    input  logic                       de,
    input  logic [                1:0] mode,
    input  logic [                3:0] sw_red,
    input  logic [                3:0] sw_green,
    input  logic [                3:0] sw_blue,
    input  logic [                9:0] x_pixel,
    input  logic [                9:0] y_pixel,
    output logic [$clog2(320*240)-1:0] addr,
    input  logic [               15:0] imgPXlData,
    output logic [                3:0] port_red,
    output logic [                3:0] port_green,
    output logic [                3:0] port_blue
);

    logic sw_clr_de, clr_bar_de, img_de;
    logic resize_x2_en;

    logic [3:0] sw_clr_red, sw_clr_green, sw_clr_blue;
    logic [3:0] clr_bar_red, clr_bar_green, clr_bar_blue;
    logic [3:0] img_red, img_green, img_blue;

    assign {port_red, port_green, port_blue} = (mode == 0)? {sw_clr_red,sw_clr_green,sw_clr_blue}:
                                                (mode == 1)? {clr_bar_red,clr_bar_green,clr_bar_blue}:
                                                {img_red,img_green,img_blue};

    always_comb begin
        sw_clr_de    = 0;
        clr_bar_de   = 0;
        img_de       = 0;
        resize_x2_en = 0;
        case (mode)
            0: sw_clr_de = 1;
            1: clr_bar_de = 1;
            2: img_de = 1;
            3: begin
                img_de = 1;
                resize_x2_en = 1;
            end
        endcase
    end

    //SW0
    VGA_RGB_SW u_VGA_RGB_SW (
        .sw_red    (sw_red),
        .sw_green  (sw_green),
        .sw_blue   (sw_blue),
        .de        (de && sw_clr_de),
        .port_red  (sw_clr_red),
        .port_green(sw_clr_green),
        .port_blue (sw_clr_blue)
    );
    //SW1
    VGA_Color_bar u_VGA_Color_bar (
        .clk       (clk),
        .reset     (reset),
        .de        (de && clr_bar_de),
        .x_pixel   (x_pixel),
        .y_pixel   (y_pixel),
        .port_red  (clr_bar_red),
        .port_green(clr_bar_green),
        .port_blue (clr_bar_blue)
    );

    //SW10,11
    VGA_img_rom_reader u_VGA_img_rom_reader (
        .de        (de && img_de),
        .resize_en (resize_x2_en),
        .x_pixel   (x_pixel),
        .y_pixel   (y_pixel),
        .addr      (addr),
        .imgPXlData(imgPXlData),
        .port_red  (img_red),
        .port_green(img_green),
        .port_blue (img_blue)
    );



endmodule
