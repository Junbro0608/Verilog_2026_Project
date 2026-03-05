`timescale 1ns / 1ps

module datapath_stopwatch (
    input         clk,
    input         reset,
    input         i_clear,
    input         i_down_up,
    input         i_run_stop,
    output [27:0] o_stopwatch_time,
    output [ 6:0] o_msec,
    output [ 5:0] o_sec,
    output [ 5:0] o_min,
    output [ 4:0] o_hour
);

    wire w_tick_100hz, w_sec_tick, w_min_tick, w_hour_tick;

    assign o_stopwatch_time = {2'b0,o_hour,1'b0,o_min,1'b0,o_sec,o_msec};

    //time_counter
    //hour
    tick_counter #(
        .BIT_WIDTH(5),
        .TIMES(24),
        .INIT_TIME(0)
    ) hour_counter (
        .clk     (clk),
        .reset   (reset),
        .clear   (i_clear),
        .i_tick  (w_hour_tick),
        .down_up (i_down_up),
        .run_stop(i_run_stop),
        .o_count (o_hour),
        .o_tick  ()
    );
    //min
    tick_counter #(
        .BIT_WIDTH(6),
        .TIMES(60),
        .INIT_TIME(0)
    ) min_counter (
        .clk     (clk),
        .reset   (reset),
        .clear   (i_clear),
        .i_tick  (w_min_tick),
        .down_up (i_down_up),
        .run_stop(i_run_stop),
        .o_count (o_min),
        .o_tick  (w_hour_tick)
    );
    //sec
    tick_counter #(
        .BIT_WIDTH(6),
        .TIMES(60),
        .INIT_TIME(0)
    ) sec_counter (
        .clk     (clk),
        .reset   (reset),
        .clear   (i_clear),
        .i_tick  (w_sec_tick),
        .down_up (i_down_up),
        .run_stop(i_run_stop),
        .o_count (o_sec),
        .o_tick  (w_min_tick)
    );
    //msec
    tick_counter #(
        .BIT_WIDTH(7),
        .TIMES(100),
        .INIT_TIME(0)
    ) msec_counter (
        .clk     (clk),
        .reset   (reset),
        .clear   (i_clear),
        .i_tick  (w_tick_100hz),
        .down_up (i_down_up),
        .run_stop(i_run_stop),
        .o_count (o_msec),
        .o_tick  (w_sec_tick)
    );

    tick_gen U_TICK_100Hz (
        .clk         (clk),
        .reset       (reset),
        .i_run_stop  (i_run_stop),
        .o_tick_100hz(w_tick_100hz)
    );

endmodule
