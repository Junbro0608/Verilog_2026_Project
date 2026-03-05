`timescale 1ns / 1ps

module dht11_controller (
    input         clk,
    input         rst,
    input         start,
    output [15:0] humidity,
    output [15:0] temperature,
    output        dht11_done,
    output        dht11_valid,
    output [ 3:0] debug,
    inout         dhtio
);
    wire tick_1us;

    tick_gen #(
        .CLK      (100_000_000),
        .FREQUENCY(1_000_000)
    ) U_TICK_1US (
        .clk       (clk),
        .reset     (rst),
        .i_run_stop(1'b1),
        .o_tick    (tick_1us)
    );

    parameter [2:0] IDLE = 0, START = 1, WAIT = 2, SYNC_L = 3, SYNC_H = 4, DATA_C = 5, STOP = 6;
    reg [2:0] c_state, n_state;
    reg dhtio_reg, dhtio_next;
    reg done_reg, done_next;
    reg valid_reg, valid_next;
    //for 19msec count by 10usec tick
    reg [$clog2(19000)-1:0] tick_cnt_reg, tick_cnt_next;
    reg io_sel_reg, io_sel_next;
    //for save input data 40bit
    reg [39:0] dht11_data_reg, dht11_data_next;
    reg [$clog2(40)-1:0] bit_cnt_reg, bit_cnt_next;

    assign dhtio = (io_sel_reg) ? dhtio_reg : 1'bz;
    assign humidity = dht11_data_reg[39:24];
    assign temperature = dht11_data_reg[23:8];
    assign dht11_done = done_reg;
    assign dht11_valid = valid_reg;
    assign debug = {dht11_valid, c_state};

    ila_0 u_ILA0 (
        .clk   (clk),
        .probe0(dhtio),   //1bit
        .probe1(debug)  //3bit
    );

    //check dhtio edge
    reg d1_dhtio, d2_dhtio;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            d1_dhtio <= 1'b0;
            d2_dhtio <= 1'b0;
        end else begin
            d1_dhtio <= dhtio;
            d2_dhtio <= d1_dhtio;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_state        <= 3'b0;
            dhtio_reg      <= 1'b1;
            done_reg       <= 1'b0;
            valid_reg      <= 1'b1;
            tick_cnt_reg   <= 0;
            io_sel_reg     <= 1'b1;
            dht11_data_reg <= 40'b0;
            bit_cnt_reg    <= 0;
        end else begin
            c_state        <= n_state;
            dhtio_reg      <= dhtio_next;
            done_reg       <= done_next;
            valid_reg      <= valid_next;
            tick_cnt_reg   <= tick_cnt_next;
            io_sel_reg     <= io_sel_next;
            dht11_data_reg <= dht11_data_next;
            bit_cnt_reg    <= bit_cnt_next;
        end
    end

    always @(*) begin
        n_state         = c_state;
        dhtio_next      = dhtio_reg;
        done_next       = done_reg;
        valid_next      = valid_reg;
        tick_cnt_next   = tick_cnt_reg;
        io_sel_next     = io_sel_reg;
        dht11_data_next = dht11_data_reg;
        bit_cnt_next    = bit_cnt_reg;
        case (c_state)
            IDLE: begin
                done_next = 1'b0;
                if (start) begin
                    n_state = START;
                    dht11_data_next = 0;
                    bit_cnt_next = 0;
                    tick_cnt_next = 0;
                end
            end
            START: begin
                dhtio_next = 1'b0;
                if (tick_1us) begin
                    tick_cnt_next = tick_cnt_reg + 1;
                    if (tick_cnt_reg == 19000) begin
                        n_state = WAIT;
                        tick_cnt_next = 0;
                    end
                end
            end
            WAIT: begin
                dhtio_next = 1'b1;
                if (tick_1us) begin
                    tick_cnt_next = tick_cnt_reg + 1;
                    if (tick_cnt_reg == 29) begin
                        n_state       = SYNC_L;
                        io_sel_next   = 1'b0;
                        tick_cnt_next = 0;
                    end
                end
            end
            SYNC_L: begin
                if (tick_1us) begin
                    if (d2_dhtio == 1) begin
                        n_state = SYNC_H;
                        tick_cnt_next = 0;
                    end
                end
            end
            SYNC_H: begin
                if (tick_1us) begin
                    if (d2_dhtio == 0) begin
                        n_state = DATA_C;
                        tick_cnt_next = 0;
                    end
                end
            end
            DATA_C: begin
                if (d2_dhtio) begin
                    if (tick_1us) begin
                        tick_cnt_next = tick_cnt_reg + 1;
                    end
                    if (d1_dhtio == 1'b0) begin
                        if (tick_cnt_reg >= 45) begin
                            dht11_data_next = {dht11_data_reg[39:0], 1'b1};
                        end else begin
                            dht11_data_next = {dht11_data_reg[39:0], 1'b0};
                        end
                        bit_cnt_next = bit_cnt_reg + 1;
                    end 
                end else begin
                    tick_cnt_next = 0;
                    if (bit_cnt_reg == 40) begin
                        n_state = STOP;
                        tick_cnt_next = 0;
                    end
                end
            end
            STOP: begin
                if (tick_1us) begin
                    tick_cnt_next = tick_cnt_reg + 1;
                    if (tick_cnt_reg == 49) begin
                        io_sel_next = 1'b1;
                        dhtio_next  = 1'b1;
                        n_state     = IDLE;
                        done_next   = 1'b1;
                        if (dht11_data_reg[7:0] == (dht11_data_reg[15:8]+dht11_data_reg[23:16]+dht11_data_reg[31:24] + dht11_data_reg[39:32])) begin
                            valid_next = 1'b1;
                        end else begin
                            valid_next = 1'b0;
                        end
                    end
                end
            end
        endcase
    end

endmodule
