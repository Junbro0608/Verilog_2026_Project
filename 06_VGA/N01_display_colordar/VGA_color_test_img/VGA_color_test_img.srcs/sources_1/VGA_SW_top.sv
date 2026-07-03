`timescale 1ns / 1ps


module VGA_SW_top (
    input  logic       clk,
    input  logic       reset,
    input  logic [3:0] sw_red,
    input  logic [3:0] sw_green,
    input  logic [3:0] sw_blue,
    input  logic       chage_sw,
    output logic       h_sync,
    output logic       v_sync,
    output logic [3:0] port_red,
    output logic [3:0] port_green,
    output logic [3:0] port_blue
);
    logic [9:0] x_pixel, y_pixel;
    logic de;
    logic [3:0] bar_img_r,bar_img_g,bar_img_b;
    logic [3:0] sw_img_r, sw_img_g, sw_img_b;

    VGA_Decoder u_VGA_Decoder (
        .clk    (clk),
        .reset  (reset),
        .h_sync (h_sync),
        .v_sync (v_sync),
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .de     (de)
    );
    VGA_RGB_img u_VGA_RGB_img (
        .clk       (clk),
        .reset     (rest),
        .de        (de),
        .x_pixel   (x_pixel),
        .y_pixel   (y_pixel),
        .port_red  (bar_img_r),
        .port_green(bar_img_g),
        .port_blue (bar_img_b)
    );

    VGA_RGB_SW u_VGA_RGB_SW (
        .sw_red    (sw_red),
        .sw_green  (sw_green),
        .sw_blue   (sw_blue),
        .de        (de),
        .x_pixel   (x_pixel),
        .y_pixel   (y_pixel),
        .port_red  (sw_img_r),
        .port_green(sw_img_g),
        .port_blue (sw_img_b)
    );

    assign {port_red,port_green,port_blue}= (chage_sw)? {bar_img_r,bar_img_g,bar_img_b}:{sw_img_r,sw_img_g,sw_img_b} ;

endmodule
