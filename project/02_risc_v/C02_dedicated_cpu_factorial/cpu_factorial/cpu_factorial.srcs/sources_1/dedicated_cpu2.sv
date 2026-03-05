`timescale 1ns / 1ps


module dedicated_cpu1 (
    input        clk,
    input        rst,
    output [7:0] out
);
    logic w_asrc_sel;
    logic w_aload, w_sumload, w_out_sel, w_equal;

    control_unit U_CTRL_UNIT (
        .clk      (clk),
        .rst      (rst),
        .i_equal  (w_equal),
        .o_src_sel(w_src_sel),
        .o_aload  (w_aload),
        .o_sumload(w_sumload),
        .o_out_sel(w_out_sel)
    );

    datapath U_DATAPATH (
        .clk      (clk),
        .rst      (rst),
        .i_src_sel(w_src_sel),
        .i_aload  (w_aload),
        .i_sumload(w_sumload),
        .i_out_sel(w_out_sel),
        .o_equal  (w_equal),
        .o_out    (out)
    );


endmodule


module control_unit (
    input              clk,
    input              rst,
    input        [7:0] i_a,
    input              i_equal,
    output logic       o_src_sel,
    output logic       o_aload,
    output logic       o_sumload,
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
        o_src_sel = 0;
        o_aload   = 0;
        o_sumload = 0;
        o_out_sel = 0;
        case (c_state)
            IDLE: begin
                o_src_sel = 1;
                o_aload   = 1;
                o_sumload = 1;
                o_out_sel = 0;
            end
            S1: begin
                o_src_sel = 0;
                o_aload   = 0;
                o_sumload = 0;
                o_out_sel = 0;
            end
            S2: begin
                o_src_sel = 1;
                o_aload   = 1;
                o_sumload = 0;
                o_out_sel = 0;
            end
            S3: begin
                o_src_sel = 1;
                o_aload   = 0;
                o_sumload = 1;
                o_out_sel = 0;
            end
            S4: begin
                o_src_sel = 0;
                o_aload   = 0;
                o_sumload = 0;
                o_out_sel = 1;
            end
        endcase
    end

endmodule



module datapath (
    input        clk,
    input        rst,
    input        i_src_sel,
    input        i_aload,
    input        i_sumload,
    input        i_out_sel,
    output       o_equal,
    output [7:0] o_out
);
    logic [7:0] w_alu_out, w_mux_out, w_a_reg_out,w_sum_reg_out, w_sum_mux_out;

    assign o_out = (i_out_sel) ? w_sum_reg_out : 0;

    mux_2x1 U_SRC_MUX (
        .i_a       (8'b0),
        .i_b       (w_alu_out),
        .i_asrc_sel(i_src_sel),
        .o_mux_out (w_mux_out)
    );

    register U_AREG (
        .clk      (clk),
        .rst      (rst),
        .i_reg_in (w_mux_out),
        .i_load   (i_aload),
        .o_reg_out(w_a_reg_out)
    );
    register U_SUMREG (
        .clk      (clk),
        .rst      (rst),
        .i_reg_in (w_mux_out),
        .i_load   (i_sumload),
        .o_reg_out(w_sum_reg_out)
    );

    mux_2x1 U_SUM_MUX (
        .i_a       (8'b1),
        .i_b       (w_sum_reg_out),
        .i_asrc_sel(i_sumload),
        .o_mux_out (w_sum_mux_out)
    );

    alu U_ALU (
        .i_a      (w_a_reg_out),
        .i_b      (w_sum_mux_out),
        .o_alu_out(w_alu_out)
    );

    lt10_compa U_10_COMP (
        .i_data (w_a_reg_out),
        .o_equal(o_equal)
    );

endmodule


module register (
    input        clk,
    input        rst,
    input  [7:0] i_reg_in,
    input        i_load,
    output [7:0] o_reg_out
);
    logic [7:0] mem;

    assign o_reg_out = mem;

    always_ff @(posedge clk or posedge rst) begin : areg_ff
        if (rst) begin
            mem <= 0;
        end else begin
            if (i_load) begin
                mem <= i_reg_in;
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


