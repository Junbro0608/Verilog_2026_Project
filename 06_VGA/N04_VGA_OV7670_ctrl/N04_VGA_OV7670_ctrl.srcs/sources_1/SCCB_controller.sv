`timescale 1ns / 1ps

module SCCB_controller (
    input  logic        clk,
    input  logic        reset,
    // user control
    input  logic        start_btn,
    // OV7670_INIT_ROM interface
    output logic [ 7:0] init_addr,
    input  logic [15:0] init_rdata,
    // AUTO_SETTING_ADDR_MEM interface
    output logic [ 7:0] set_addr,
    input  logic [ 7:0] set_data,
    // SCCB interface
    input  logic        ready,
    input  logic [ 7:0] sccb_rdata,
    output logic [ 7:0] o_addr,
    output logic [ 7:0] o_wdata,
    output logic        en,
    output logic        write

);

    typedef enum logic [3:0] {
        S0,
        S1,
        S2,
        D2,
        D3,
        S3,
        D4,
        S4,
        S5,
        D5,
        S6,
        S7,
        S8,
        S9,
        S10
    } sccb_state;

    sccb_state state, next_state;

    localparam int CLK_FREQ_HZ = 100_000_000;
    localparam int DELAY_COUNT_30 = CLK_FREQ_HZ / 1000 * 30;
    localparam int DELAY_COUNT_10 = CLK_FREQ_HZ / 1000 * 10;
    localparam int DELAY_COUNT_1 = CLK_FREQ_HZ / 1000 * 1;
    localparam int DELAY_COUNT_42 = CLK_FREQ_HZ / 1000 * 42;
    logic [$clog2(DELAY_COUNT_30)-1:0] delay_cnt_30;
    logic [$clog2(DELAY_COUNT_10)-1:0] delay_cnt_10;
    logic [$clog2(DELAY_COUNT_1)-1:0] delay_cnt_1;


    logic [$clog2(42)-1:0] cnt_42;
    logic [$clog2(8)-1:0] cnt_8;
    logic [$clog2(6)-1:0] cnt_6;
    logic [$clog2(2)-1:0] cnt_2;

    logic [7:0] temp0;
    logic [7:0] temp1;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end

    end

    always_comb begin
        next_state = state;
        o_addr     = 0;
        o_wdata    = 0;
        en         = 0;
        write      = 0;
        init_addr  = 0;
        set_addr   = 0;
        addr       = 0;

        case (state)
            S0: begin
                if (start_btn) begin
                    next_state = S1;
                end
            end

            S1: begin
                if (ready) begin
                    o_addr  = init_rdata[15:8];
                    o_wdata = init_rdata[7:0];
                    en      = 1;
                    write   = 1;
                end
                if (delay_cnt_30 == DELAY_COUNT_30) begin
                    delay_cnt_30 = 0;
                    init_addr = 1;
                    state = S2;
                end else begin
                    delay_cnt_30 = delay_cnt_30 + 1;
                end
            end

            S2: begin
                if (cnt_42 == 42) begin
                    cnt_42 = 0;
                    state  = D3;
                end else begin
                    if (ready) begin
                        cnt_42    = cnt_42 + 1;
                        init_addr = 1 + cnt_42;
                        o_addr    = init_rdata[15:8];
                        o_wdata   = init_rdata[7:0];
                        en        = 1;
                        write     = 1;
                        state <= D2;
                    end
                end

            end
            D2: begin
                if (delay_cnt_1 == DELAY_COUNT_1) begin
                    delay_cnt_1 = 0;
                    state = S2;
                end else begin
                    delay_cnt_1 = delay_cnt_1 + 1;
                end
            end

            D3: begin  // HAL_Delay(10);
                if (delay_cnt_10 == DELAY_COUNT_10) begin
                    delay_cnt_10 = 0;
                    state = S3;
                end else begin
                    delay_cnt_10 = delay_cnt_10 + 1;
                end
            end

            S3: begin
                if (cnt_8 == 8) begin
                    cnt_8 = 0;
                    state = S4;
                end else begin
                    if (ready) begin
                        cnt_8     = cnt_8 + 1;
                        init_addr = 43 + cnt_8;
                        o_addr    = init_rdata[15:8];
                        o_wdata   = init_rdata[7:0];
                        en        = 1;
                        write     = 1;
                        state <= D4;
                    end
                end
            end
            D4: begin
                if (delay_cnt_1 == DELAY_COUNT_1) begin
                    delay_cnt_1 = 0;
                    state = S3;
                end else begin
                    delay_cnt_1 = delay_cnt_1 + 1;
                end
            end
            S4: begin
                if (cnt_6 == 6) begin
                    cnt_6 = 0;
                    state = S5;
                end else begin
                    if (ready) begin
                        cnt_6     = cnt_6 + 1;
                        init_addr = 51 + cnt_6;
                        o_addr    = init_rdata[15:8];
                        o_wdata   = init_rdata[7:0];
                        en        = 1;
                        write     = 1;
                    end
                end
            end

            S5: begin
                if (cnt_2 == 2) begin
                    cnt_2 = 0;
                    state = D5;
                end else begin
                    if (ready) begin
                        cnt_2 = cnt_2 + 1;
                        if (cnt_2 == 1) begin
                            temp0 = sccb_rdata;
                        end else if (cnt_2 == 2) begin
                            temp1 = sccb_rdata;
                        end
                        en    = 1;
                        write = 0;
                    end
                end
            end
            D5: begin
                if (delay_cnt_10 == DELAY_COUNT_10) begin
                    delay_cnt_10 = 0;
                    state = S6;
                end else begin
                    delay_cnt_10 = delay_cnt_10 + 1;
                end
            end

            S6: begin
                if (cnt_2 == 2) begin
                    cnt_2 = 0;
                    state = S7;
                end else begin
                    if (ready) begin
                        cnt_2 = cnt_2 + 1;
                        if (cnt_2 == 1) begin
                            o_wdata  = (temp0 & 8'b11111010) | 8'h04;
                            set_addr = 2;
                            o_addr   = set_data;
                        end else if (cnt_2 == 2) begin
                            o_wdata  = (temp1 & 8'b00001111) | 8'h10;
                            set_addr = 3;
                            o_addr   = set_data;
                        end
                        en    = 1;
                        write = 1;
                    end
                end
            end

            S7: begin
                if (ready) begin
                    temp0 = sccb_rdata;
                    en = 1;
                    write = 0;
                end
                state = S8;
            end

            S8: begin
                if (cnt_2 == 2) begin
                    cnt_2 = 0;
                    state = S9;
                end else begin
                    if (ready) begin
                        cnt_2 = cnt_2 + 1;
                        if (cnt_2 == 1) begin
                            o_wdata  = temp0 | 8'h01;
                            set_addr = 5;
                            o_addr   = set_data;
                        end else if (cnt_2 == 2) begin
                            o_wdata  = 8'h87;
                            set_addr = 6;
                            o_addr   = set_data;
                        end
                        en    = 1;
                        write = 1;
                    end
                end
            end

            S9: begin
                if (ready) begin
                    temp1 = sccb_rdata;
                    en = 1;
                    write = 0;
                end
                state = S10;
            end

            S10: begin
                if (ready) begin
                    o_wdata  = temp1 | 8'h04;
                    set_addr = 8;
                    o_addr   = set_data;
                end
                state = S0;
            end

            default: begin

            end

        endcase
    end


endmodule

