`timescale 1ns / 1ps


module dedicated_cpu4 #(
    parameter BIT_WIDTH = 8,
    ADDR = 4
) (
    input        clk,
    input        rst,
    output [7:0] out
);
    logic w_asrc_sel;
    logic rfsrc_sel, w_equal;
    logic we;
    logic [$clog2(ADDR)-1:0] waddr, raddr0, raddr1;

    control_unit #(
        .ADDR(ADDR)
    ) U_CTRL_UNIT (
        .clk(clk),
        .rst(rst),
        //equal
        .i_equal(w_equal),
        //src
        .rfsrc_sel(rfsrc_sel),
        //write
        .we(we),
        .waddr(waddr),
        //read
        .raddr0(raddr0),
        .raddr1(raddr1)
    );


    datapath #(
        .BIT_WIDTH(BIT_WIDTH),
        .ADDR(ADDR)
    ) U_DATAPATH (
        .clk(clk),
        .rst(rst),
        //src
        .rfsrc_sel(rfsrc_sel),
        //write
        .we(we),
        .waddr(waddr),
        //read
        .raddr0(raddr0),
        .raddr1(raddr1),
        //output
        .o_equal(w_equal),
        .o_out(out)
    );


endmodule


module control_unit #(
    ADDR = 4
) (
    input clk,
    input rst,

    input i_equal,

    output logic                    rfsrc_sel,
    //write
    output logic                    we,
    output logic [$clog2(ADDR)-1:0] waddr,
    //read
    output logic [$clog2(ADDR)-1:0] raddr0,
    output logic [$clog2(ADDR)-1:0] raddr1

);
    typedef enum logic [2:0] {
        S0,
        S1,
        S2,
        S3,
        S4,
        S5,
        S6
    } state_t;

    state_t c_state, n_state;




    always_ff @(posedge clk or posedge rst) begin : ctrl_u_ff
        if (rst) begin
            c_state <= S0;
        end else begin
            c_state <= n_state;
        end
    end

    always_comb begin : state_comb
        n_state = c_state;
        case (c_state)
            S0: n_state = S1;
            S1: n_state = S2;
            S2: n_state = S3;
            S3: begin
                if (i_equal) n_state = S6;
                else n_state = S4;
            end
            S4: n_state = S5;
            S5: n_state = S3;
        endcase
    end

    always_comb begin : output_comb
        we        = 0;
        waddr     = 0;
        rfsrc_sel = 0;
        raddr0    = 0;
        raddr1    = 0;
        case (c_state)
            S0: begin   //R3 = 1
                rfsrc_sel = 0;
                we        = 1;
                waddr     = 3;
                raddr0    = 0;
                raddr1    = 0;
            end
            S1: begin   //R1 = R0 + R0
                rfsrc_sel = 1;
                we        = 1;
                waddr     = 1;
                raddr0    = 0;
                raddr1    = 0;
            end
            S2: begin   // R2 = R0 + R0
                rfsrc_sel = 1;
                we        = 1;
                waddr     = 2;
                raddr0    = 0;
                raddr1    = 0;
            end
            S3: begin   //lg10 == 1
                rfsrc_sel = 1;
                we        = 0;
                waddr     = 0;
                raddr0    = 1;
                raddr1    = 0;
            end
            S4: begin   //R2 = R1 + R2
                rfsrc_sel = 1;
                we        = 1;
                waddr     = 2;
                raddr0    = 1;
                raddr1    = 2;
            end
            S5: begin   //R1 = R1 + R3
                rfsrc_sel = 1;
                we        = 1;
                waddr     = 1;
                raddr0    = 1;
                raddr1    = 3;
            end
            S6: begin   //out = R2
                rfsrc_sel = 1;
                we        = 0;
                waddr     = 0;
                raddr0    = 2;
                raddr1    = 0;
            end
        endcase
    end

endmodule



module datapath #(
    parameter BIT_WIDTH = 8,
    ADDR = 4
) (
    input                     clk,
    input                     rst,
    input                     rfsrc_sel,
    //write
    input                     we,
    input  [$clog2(ADDR)-1:0] waddr,
    //read
    input  [$clog2(ADDR)-1:0] raddr0,
    input  [$clog2(ADDR)-1:0] raddr1,
    //output
    output                    o_equal,
    output [             7:0] o_out
);
    logic [7:0] w_alu_out, w_reg_mux_out;
    logic [BIT_WIDTH-1:0] rd0, rd1;

    assign o_out = rd0;

    mux_2x1 U_REG_MUX (
        .i_a       (8'b1),
        .i_b       (w_alu_out),
        .i_asrc_sel(rfsrc_sel),
        .o_mux_out (w_reg_mux_out)
    );

    register_file #(
        .BIT_WIDTH(BIT_WIDTH),
        .ADDR     (ADDR)
    ) U_register (
        .clk   (clk),
        .rst   (rst),
        //write
        .we    (we),
        .waddr (waddr),
        .wdata (w_reg_mux_out),
        //read
        .raddr0(raddr0),
        .rd0   (rd0),
        .raddr1(raddr1),
        .rd1   (rd1)
    );


    alu U_ALU (
        .i_rd0    (rd0),
        .i_rd1    (rd1),
        .o_alu_out(w_alu_out)
    );

    lt10_compa U_10_COMP (
        .i_data (rd0),
        .o_equal(o_equal)
    );

endmodule


module register_file #(
    parameter BIT_WIDTH = 8,
    ADDR = 4
) (
    input                           clk,
    input                           rst,
    //write
    input                           we,
    input        [$clog2(ADDR)-1:0] waddr,
    input        [   BIT_WIDTH-1:0] wdata,
    //read
    input        [$clog2(ADDR)-1:0] raddr0,
    output logic [   BIT_WIDTH-1:0] rd0,
    input        [$clog2(ADDR)-1:0] raddr1,
    output logic [   BIT_WIDTH-1:0] rd1
);
    logic [7:0] mem[0:ADDR-1];

    assign rd0 = mem[raddr0];
    assign rd1 = mem[raddr1];

    initial begin
        mem[0] = 0;
    end


    always_ff @(posedge clk or posedge rst) begin : areg_ff
        if (rst) begin
        end else begin
            if (we) begin
                mem[waddr] = wdata;
            end
        end
    end

endmodule


module alu (
    input  [7:0] i_rd0,
    input  [7:0] i_rd1,
    output [7:0] o_alu_out
);

    assign o_alu_out = i_rd0 + i_rd1;

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
    assign o_equal = (i_data == 11);
endmodule


