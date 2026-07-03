`timescale 1ns / 1ps

module VGA_Color_bar (
    input  logic       clk,
    input  logic       reset,
    input  logic       de,
    input  logic [9:0] x_pixel,
    input  logic [9:0] y_pixel,
    output logic [3:0] port_red,
    output logic [3:0] port_green,
    output logic [3:0] port_blue
);

    localparam WHITE = 12'hfff;
    localparam YELLOW = 12'hff0;
    localparam MINT = 12'hff;
    localparam GREEN = 12'hf0;
    localparam MAGENTA = 12'hf0f;
    localparam RED = 12'hf00;
    localparam BLUE = 12'hf;
    localparam BLACK = 12'h0;
    localparam PUPLE = 12'h305;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            port_red   <= 0;
            port_green <= 0;
            port_blue  <= 0;
        end else begin
            if (!de) begin
                port_red   <= 0;
                port_green <= 0;
                port_blue  <= 0;
            end else begin
                if (y_pixel < 336) begin
                    if (x_pixel < 92) begin
                        {port_red, port_green, port_blue} <= WHITE;
                    end else if (x_pixel < 184) begin
                        {port_red, port_green, port_blue} <= YELLOW;
                    end else if (x_pixel < 276) begin
                        {port_red, port_green, port_blue} <= MINT;
                    end else if (x_pixel < 368) begin
                        {port_red, port_green, port_blue} <= GREEN;
                    end else if (x_pixel < 460) begin
                        {port_red, port_green, port_blue} <= MAGENTA;
                    end else if (x_pixel < 552) begin
                        {port_red, port_green, port_blue} <= RED;
                    end else begin
                        {port_red, port_green, port_blue} <= BLUE;
                    end
                end else if (y_pixel < 384) begin
                    if (x_pixel < 92) begin
                        {port_red, port_green, port_blue} <= BLUE;
                    end else if (x_pixel < 184) begin
                        {port_red, port_green, port_blue} <= BLACK;
                    end else if (x_pixel < 276) begin
                        {port_red, port_green, port_blue} <= MAGENTA;
                    end else if (x_pixel < 368) begin
                        {port_red, port_green, port_blue} <= BLACK;
                    end else if (x_pixel < 460) begin
                        {port_red, port_green, port_blue} <= MINT;
                    end else if (x_pixel < 552) begin
                        {port_red, port_green, port_blue} <= BLACK;
                    end else begin
                        {port_red, port_green, port_blue} <= WHITE;
                    end
                end else begin
                    if (x_pixel < 106) begin
                        {port_red, port_green, port_blue} <= {4'h0,4'h1,4'h1};
                    end else if (x_pixel < 106 * 2) begin
                        {port_red, port_green, port_blue} <= WHITE;
                    end else if (x_pixel < 106 * 3) begin
                        {port_red, port_green, port_blue} <= PUPLE;
                    end else if (x_pixel < 106 * 4) begin
                        {port_red, port_green, port_blue} <= BLACK;
                    end else if (x_pixel < 106 * 4 + (106 / 3)) begin
                        {port_red, port_green, port_blue} <= {4'h1,4'h1,4'h1};
                    end else if (x_pixel < 106 * 4 + (106 / 3) * 2) begin
                        {port_red, port_green, port_blue} <= {4'h2,4'h2,4'h2};
                    end else if (x_pixel < 106 * 4 + (106 / 3) * 3) begin
                        {port_red, port_green, port_blue} <= {4'h3,4'h3,4'h3};
                    end else begin
                        {port_red, port_green, port_blue} <= BLACK;
                    end
                end
            end
        end
    end

endmodule
