`timescale 1ns / 1ps

module VGA_RGB_img (
    input  logic       clk,
    input  logic       reset,
    input  logic       de,          
    input  logic [9:0] x_pixel,  
    input  logic [9:0] y_pixel,     
    output logic [3:0] port_red,
    output logic [3:0] port_green,
    output logic [3:0] port_blue
);

    localparam logic [3:0] White[0:2] = '{15, 15, 15};
    localparam logic [3:0] Yellow[0:2] = '{15, 15, 0};
    localparam logic [3:0] Mint[0:2] = '{0, 15, 15};
    localparam logic [3:0] Green[0:2] = '{0, 15, 0};
    localparam logic [3:0] Magenta[0:2] = '{15, 0, 15};
    localparam logic [3:0] Red[0:2] = '{15, 0, 0};
    localparam logic [3:0] Blue[0:2] = '{0, 0, 15};
    localparam logic [3:0] Black[0:2] = '{0, 0, 0};
    localparam logic [3:0] Puple[0:2] = '{3, 0, 5};

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
                        port_red   <= 15;
                        port_green <= 15;
                        port_blue  <= 15;
                    end else if (x_pixel < 184) begin
                        port_red   <= 15;
                        port_green <= 15;
                        port_blue  <= 0;
                    end else if (x_pixel < 276) begin
                        port_red   <= 0;
                        port_green <= 15;
                        port_blue  <= 15;
                    end else if (x_pixel < 368) begin
                        port_red   <= 0;
                        port_green <= 15;
                        port_blue  <= 0;
                    end else if (x_pixel < 460) begin
                        port_red   <= 15;
                        port_green <= 0;
                        port_blue  <= 15;
                    end else if (x_pixel < 552) begin
                        port_red   <= 15;
                        port_green <= 0;
                        port_blue  <= 0;
                    end else begin
                        port_red   <= 0;
                        port_green <= 0;
                        port_blue  <= 15;
                    end
                end else if (y_pixel < 384) begin
                    if (x_pixel < 92) begin
                        port_red   <= 0;
                        port_green <= 0;
                        port_blue  <= 15;
                    end else if (x_pixel < 184) begin
                        port_red   <= 0;
                        port_green <= 0;
                        port_blue  <= 0;
                    end else if (x_pixel < 276) begin
                        port_red   <= 15;
                        port_green <= 0;
                        port_blue  <= 15;
                    end else if (x_pixel < 368) begin
                        port_red   <= 0;
                        port_green <= 0;
                        port_blue  <= 0;
                    end else if (x_pixel < 460) begin
                        port_red   <= 0;
                        port_green <= 15;
                        port_blue  <= 15;
                    end else if (x_pixel < 552) begin
                        port_red   <= 0;
                        port_green <= 0;
                        port_blue  <= 0;
                    end else begin
                        port_red   <= 15;
                        port_green <= 15;
                        port_blue  <= 15;
                    end
                end else begin
                    if (x_pixel < 106) begin
                        port_red   <= 0;
                        port_green <= 1;
                        port_blue  <= 1;
                    end else if (x_pixel < 106 * 2) begin
                        port_red   <= 15;
                        port_green <= 15;
                        port_blue  <= 15;
                    end else if (x_pixel < 106 * 3) begin
                        port_red   <= 3;
                        port_green <= 0;
                        port_blue  <= 5;
                    end else if (x_pixel < 106 * 4) begin
                        port_red   <= 0;
                        port_green <= 0;
                        port_blue  <= 0;
                    end else if (x_pixel < 106 * 4 + (106 / 3)) begin
                        port_red   <= 1;
                        port_green <= 1;
                        port_blue  <= 1;
                    end else if (x_pixel < 106 * 4 + (106 / 3) * 2) begin
                        port_red   <= 2;
                        port_green <= 2;
                        port_blue  <= 2;
                    end else if (x_pixel < 106 * 4 + (106 / 3) * 3) begin
                        port_red   <= 3;
                        port_green <= 3;
                        port_blue  <= 3;
                    end else begin
                        port_red   <= 0;
                        port_green <= 0;
                        port_blue  <= 0;
                    end
                end
            end
        end
    end

endmodule
