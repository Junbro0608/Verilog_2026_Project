`timescale 1ns / 1ps
module top_sr04 (
    input        clk,
    input        rst,
    input        start,
    input        echo,
    output       trigger,
    output [9:0] o_dist_sr04
);
    wire o_tick_us, tick_gen_start;
    wire [8:0] w_dist_sr04;
    assign o_dist_sr04[9:7] = w_dist_sr04 / 100;
    assign o_dist_sr04[6:0] = w_dist_sr04 % 100;

    tick_gen #(
        .CLK      (100_000_000),
        .FREQUENCY(1_000_000)
    ) U_TICK_GEN_US (
        .clk       (clk),
        .reset     (rst),
        .i_run_stop(tick_gen_start),
        .o_tick    (o_tick_us)
    );

    sr04_controller U_SR04_CTRL (
        .clk           (clk),
        .rst           (rst),
        .tick_us       (o_tick_us),
        .start         (start),
        .echo          (echo),
        .tick_gen_start(tick_gen_start),
        .trigger       (trigger),
        .dist_sr04     (w_dist_sr04)
    );

endmodule

module sr04_controller (
    input        clk,
    input        rst,
    input        tick_us,
    input        start,
    input        echo,
    output       tick_gen_start,
    output       trigger,
    output [8:0] dist_sr04
);

    localparam [1:0] IDLE = 2'd0, S_START = 2'd1, S_WAIT = 2'd2, S_DIST = 2'd3;

    reg trigger_reg, trigger_next;
    reg [1:0] c_state, n_state;
    reg tick_gen_start_reg, tick_gen_start_next;
    reg [5:0] tick_cnt_reg, tick_cnt_next;
    reg [8:0] dist_reg, dist_next;

    assign tick_gen_start = tick_gen_start_reg;
    assign trigger = trigger_reg;
    assign dist_sr04 = dist_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_state            <= IDLE;
            trigger_reg        <= 1'b0;
            tick_gen_start_reg <= 1'b0;
            tick_cnt_reg       <= 6'b0;
            dist_reg           <= 9'b0;
        end else begin
            c_state            <= n_state;
            trigger_reg        <= trigger_next;
            tick_gen_start_reg <= tick_gen_start_next;
            tick_cnt_reg       <= tick_cnt_next;
            dist_reg           <= dist_next;
        end
    end


    always @(*) begin
        n_state             = c_state;
        trigger_next        = trigger_reg;
        tick_gen_start_next = tick_gen_start_reg;
        tick_cnt_next       = tick_cnt_reg;
        dist_next           = dist_reg;
        case (c_state)
            IDLE: begin
                tick_cnt_next = 0;
                if (start) begin
                    n_state             = S_START;
                    trigger_next        = 1'b1;
                    tick_gen_start_next = 1'b1;
                    dist_next           = 9'b0;
                end
            end
            S_START: begin
                if (tick_us)
                    if (tick_cnt_reg == 15'd10) begin  //11us
                        n_state      = S_WAIT;
                        trigger_next = 1'b0;
                    end else begin
                        tick_cnt_next = tick_cnt_reg + 1;
                    end
            end
            S_WAIT: begin
                tick_cnt_next = 0;
                if (echo) begin
                    n_state = S_DIST;
                end
            end
            S_DIST: begin
                if (tick_us) begin
                    tick_cnt_next = tick_cnt_reg + 1;
                    if (tick_cnt_reg == 6'd57) begin
                        dist_next = dist_reg + 1;
                        tick_cnt_next = 0;
                    end
                end
                if ((echo == 0) || (dist_reg == 9'd400)) begin  //STOP
                    n_state             = IDLE;
                    tick_gen_start_next = 1'b0;
                end
            end
        endcase
    end

endmodule
