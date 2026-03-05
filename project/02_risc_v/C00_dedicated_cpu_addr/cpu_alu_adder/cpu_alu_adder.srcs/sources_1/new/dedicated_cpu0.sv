`timescale 1ns / 1ps


module dedicated_cpu0 (
    input        clk,
    input        rst,
    output [7:0] out
);
    logic w_asrc_sel, w_aload;

    control_unit U_CTRL_UNIT (
        .clk       (clk),
        .rst       (rst),
        .o_asrc_sel(w_asrc_sel),
        .o_aload   (w_aload)
    );

    datapath U_DATAPATH (
        .clk       (clk),
        .rst       (rst),
        .i_asrc_sel(w_asrc_sel),
        .i_aload   (w_aload),
        .o_out     (out)
    );


endmodule


module control_unit (
    input clk,
    input rst,
    output logic o_asrc_sel,
    output logic o_aload
);
    typedef enum logic [2:0] {
        IDLE = 0,
        SET_DATA = 1,
        ALU = 2
    } state_t;

    state_t c_state, n_state;




    always_ff @(posedge clk or posedge rst) begin : ctrl_u_ff
        if (rst) begin
            c_state    <= IDLE;
        end else begin
            c_state    <= n_state;
        end
    end

    always_comb begin : state_comb
        n_state = c_state;
        case (c_state)
            IDLE:     n_state = SET_DATA;
            SET_DATA: n_state = ALU;
            // ALU:      n_state = IDLE;
        endcase
    end

    always_comb begin : output_comb
        o_asrc_sel = 0;
        o_aload    = 0;
        case (c_state)
            IDLE: begin
                o_asrc_sel = 0;
                o_aload    = 0;
            end
            SET_DATA: begin
                o_asrc_sel = 0;
                o_aload    = 1;
            end
            ALU: begin
                o_asrc_sel = 1;
                o_aload    = 1;
            end

        endcase
    end

endmodule



module datapath (
    input        clk,
    input        rst,
    input        i_asrc_sel,
    input        i_aload,
    output [7:0] o_out
);
    logic [7:0] w_alu_out, w_mux_out, w_reg_out;

    assign o_out = w_alu_out;

    mux_2x1 U_ASRC_MUX (
        .i_a       (8'b0),
        .i_b       (w_alu_out),
        .i_asrc_sel(i_asrc_sel),
        .o_mux_out (w_mux_out)
    );

    areg U_AREG (
        .clk      (clk),
        .rst      (rst),
        .i_reg_in (w_mux_out),
        .i_aload  (i_aload),
        .o_reg_out(w_reg_out)
    );

    alu U_ALU (
        .i_a      (w_reg_out),
        .i_b      (8'h1),
        .o_alu_out(w_alu_out)
    );

endmodule


module areg (
    input        clk,
    input        rst,
    input  [7:0] i_reg_in,
    input        i_aload,
    output [7:0] o_reg_out
);
    logic [7:0] areg;

    assign o_reg_out = areg;

    always_ff @(posedge clk or posedge rst) begin : areg_ff
        if (rst) begin
            areg <= 0;
        end else begin
            if (i_aload) begin
                areg <= i_reg_in;
            end
        end
    end

endmodule


module alu (
    input  [7:0] i_a,
    input  [7:0] i_b,
    output [7:0] o_alu_out
);

    assign o_alu_out = i_a + i_b;

endmodule


module mux_2x1 (
    input  [7:0] i_a,
    input  [7:0] i_b,
    input        i_asrc_sel,
    output [7:0] o_mux_out
);
    assign o_mux_out = (i_asrc_sel) ? i_b : i_a;
endmodule
