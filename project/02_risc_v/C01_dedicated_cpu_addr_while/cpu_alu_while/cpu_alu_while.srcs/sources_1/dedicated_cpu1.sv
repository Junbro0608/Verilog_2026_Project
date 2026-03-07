`timescale 1ns / 1ps


module dedicated_cpu1 (
    input        clk,
    input        rst,
    output [7:0] out
);
    logic w_asrc_sel, w_aload, w_out_sel, w_equal;

    control_unit U_CTRL_UNIT (
        .clk       (clk),
        .rst       (rst),
        .i_equal   (w_equal),
        .o_asrc_sel(w_asrc_sel),
        .o_aload   (w_aload),
        .o_out_sel (w_out_sel)
    );

    datapath U_DATAPATH (
        .clk       (clk),
        .rst       (rst),
        .i_asrc_sel(w_asrc_sel),
        .i_aload   (w_aload),
        .i_out_sel (w_out_sel),
        .o_equal   (w_equal),
        .o_out     (out)
    );


endmodule


module control_unit (
    input              clk,
    input              rst,
    input        [7:0] i_a,
    input              i_equal,
    output logic       o_asrc_sel,
    output logic       o_aload,
    output logic       o_out_sel
);
    typedef enum logic [2:0] {
        IDLE,
        S1,
        S2,
        S3,
        S4
    } state_t;

    state_t c_state, n_state;




    always_ff @(posedge clk or posedge rst) begin : ctrl_u_ff
        if (rst) begin
            c_state <= IDLE;
        end else begin
            c_state <= n_state;
        end
    end

    always_comb begin : state_comb
        n_state = c_state;
        case (c_state)
            IDLE: n_state = S1;
            S1: begin
                if (i_equal) n_state = S4;
                else n_state = S2;
            end
            S2:   n_state = S3;
            S3:   n_state = S1;
        endcase
    end

    always_comb begin : output_comb
        o_asrc_sel = 0;
        o_aload    = 0;
        o_out_sel  = 0;
        case (c_state)
            IDLE: begin
                o_asrc_sel = 0;
                o_aload    = 0;
                o_out_sel  = 0;
            end
            S1: begin
                o_asrc_sel = 0;
                o_aload    = 0;
                o_out_sel  = 0;
            end
            S2: begin
                o_asrc_sel = 0;
                o_aload    = 0;
                o_out_sel  = 1;
            end
            S3: begin
                o_asrc_sel = 1;
                o_aload    = 1;
                o_out_sel  = 0;
            end
            S4: begin
                o_asrc_sel = 0;
                o_aload    = 0;
                o_out_sel  = 1;
            end
        endcase
    end

endmodule



module datapath (
    input        clk,
    input        rst,
    input        i_asrc_sel,
    input        i_aload,
    input        i_out_sel,
    output       o_equal,
    output [7:0] o_out
);
    logic [7:0] w_alu_out, w_mux_out, w_reg_out;

    assign o_out = (i_out_sel) ? w_reg_out : 0;

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

    lt10_compa U_10_COMP (
        .i_data (w_reg_out),
        .o_equal(o_equal)
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

module lt10_compa (
    input  [7:0] i_data,
    output       o_equal
);
    assign o_equal = (i_data == 10);
endmodule
