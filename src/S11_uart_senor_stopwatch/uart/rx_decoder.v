`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/08 15:27:19
// Design Name: 
// Module Name: rx_decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rx_decoder (
    input            clk,
    input            rst,
    input      [7:0] i_rx_data,
    input            i_rx_done,
    output reg       o_clear,
    output reg       o_run_stop,
    output reg       o_up,
    output reg       o_down,
    output reg       o_send_start,
    output reg       o_mode,
    output reg       o_fnd_sel
);

    localparam [7:0] ASCII_R = 8'h52,
                     ASCII_L = 8'h4c,
                     ASCII_U = 8'h55, 
                     ASCII_D = 8'h44,
                     ASCII_S = 8'h53,
                     ASCII_0 = 8'h30,
                     ASCII_1 = 8'h31;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_run_stop   <= 1'b0;
            o_clear      <= 1'b0;
            o_up         <= 1'b0;
            o_down       <= 1'b0;
            o_mode       <= 1'b0;
            o_fnd_sel    <= 1'b0;
            o_send_start <= 1'b0;
        end else begin
            if (i_rx_done) begin
                if ((i_rx_data == ASCII_R) || (i_rx_data == (ASCII_R + 8'h20))) begin
                    o_run_stop <= 1'b1;
                end else if((i_rx_data == ASCII_L) || (i_rx_data == (ASCII_L + 8'h20))) begin
                    o_clear <= 1'b1;
                end else if((i_rx_data == ASCII_U) || (i_rx_data == (ASCII_U + 8'h20))) begin
                    o_up <= 1'b1;
                end else if ((i_rx_data == ASCII_D) || (i_rx_data == (ASCII_D + 8'h20))) begin
                    o_down <= 1'b1;
                end else if ((i_rx_data == ASCII_S) || (i_rx_data == (ASCII_S + 8'h20))) begin
                    o_send_start <= 1'b1;
                end else if (i_rx_data == ASCII_0) begin
                    o_mode = 1'b1;
                end else if (i_rx_data == ASCII_1) begin
                    o_fnd_sel <= 1'b1;
                end
            end else begin
                o_run_stop   <= 1'b0;
                o_clear      <= 1'b0;
                o_up         <= 1'b0;
                o_down       <= 1'b0;
                o_send_start <= 1'b0;
                o_mode       <= 1'b0;
                o_fnd_sel    <= 1'b0;
            end
        end
    end

endmodule
