`timescale 1ns / 1ps

module datapath_watch (
    input        clk,
    input        reset,
    input        i_clear,
    input  [1:0] i_time_modify,
    output [27:0] o_watch_time,
    output [6:0] o_msec,
    output [5:0] o_sec,
    output [5:0] o_min,
    output [4:0] o_hour
);
    wire w_tick_100hz, w_sec_tick, w_min_tick, w_hour_tick;
    wire [6:0] c_msec;
    wire [5:0] c_sec;
    wire [5:0] c_min;
    wire [4:0] c_hour;
    reg [23:0] add_data_reg;
    wire [23:0] add_data_next;
    wire [23:0] w_add_data, w_sum_full;
    reg [23:0] up_down_time;

    assign o_watch_time = {2'b0,o_hour,1'b0,o_min,1'b0,o_sec,o_msec};

    //SL
    always @(posedge clk or posedge reset) begin
        if (reset || i_clear) begin
            add_data_reg <= 24'b0;
        end else begin
            add_data_reg <= add_data_next;
        end

    end

    assign w_add_data = add_data_reg;
    //CL
    always @(*) begin
        case(i_time_modify)
        2'b10:up_down_time = {5'd0, 6'd1, 6'd0, 7'd0};
        2'b01:up_down_time = {5'd23, 6'd59, 6'd0, 7'd0};
        default:up_down_time = 24'd0;
        endcase
    end

    sum_clock U_SUM_ADD (
        .time0(up_down_time),
        .time1(add_data_reg),
        .o_sum_data(add_data_next)
    );

    sum_clock U_SUM_OUT (
        .time0({c_hour, c_min, c_sec, c_msec}),
        .time1(w_add_data),
        .o_sum_data({o_hour, o_min, o_sec, o_msec})
    );
    // assign o_hour = c_hour;
    // assign o_min  = c_min;
    // assign o_sec  = c_sec;
    // assign o_msec = c_msec;
    //time_counter
    //hour
    tick_counter #(
        .BIT_WIDTH(5),
        .TIMES(24),
        .INIT_TIME(12)
    ) hour_counter (
        .clk     (clk),
        .reset   (reset),
        .clear   (i_clear),
        .i_tick  (w_hour_tick),
        .down_up (0),
        .run_stop(1),
        .o_count (c_hour),
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
        .down_up (0),
        .run_stop(1),
        .o_count (c_min),
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
        .down_up (0),
        .run_stop(1),
        .o_count (c_sec),
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
        .down_up (0),
        .run_stop(1),   
        .o_count (c_msec),
        .o_tick  (w_sec_tick)
    );

    tick_gen U_TICK_100Hz (
        .clk         (clk),
        .reset       (reset),
        .i_run_stop  (1),
        .o_tick_100hz(w_tick_100hz)
    );
endmodule

module sum_clock (
    input  [23:0] time0,
    input  [23:0] time1,
    output [23:0] o_sum_data
);
    reg c_min, c_sec, c_msec;
    

    reg [7:0] r_sum_ms;   
    reg [6:0] r_sum_s;    
    reg [6:0] r_sum_m;    
    reg [5:0] r_sum_h;    

    assign o_sum_data = {
        r_sum_h[4:0],
        r_sum_m[5:0],
        r_sum_s[5:0],
        r_sum_ms[6:0]
    };

    always @(*) begin
        // 1. msec (0~99)
        r_sum_ms = time0[6:0] + time1[6:0];
        if (r_sum_ms >= 8'd100) begin
            r_sum_ms = r_sum_ms - 8'd100;
            c_msec = 1'b1;
        end else begin
            c_msec = 1'b0;
        end

        // 2. sec (0~59)
        r_sum_s = time0[12:7] + time1[12:7] + c_msec;
        if (r_sum_s >= 7'd60) begin
            r_sum_s = r_sum_s - 7'd60;
            c_sec = 1'b1;
        end else begin
            c_sec = 1'b0;
        end

        // 3. min (0~59)
        r_sum_m = time0[18:13] + time1[18:13] + c_sec;
        if (r_sum_m >= 7'd60) begin
            r_sum_m = r_sum_m - 7'd60;
            c_min = 1'b1;
        end else begin
            c_min = 1'b0;
        end

        // 4. hour (0~23)
        r_sum_h = time0[23:19] + time1[23:19] + c_min;
        if (r_sum_h >= 6'd24) begin
            r_sum_h = r_sum_h - 6'd24;
        end
    end
endmodule
