module spi_slave (
    input              clk,
    input              rst,
    //spi_protocals
    input              sclk,
    input              cs_n,
    input              mosi,
    output logic       miso,
    //slave I/O
    input        [7:0] slv_tx_data,
    output logic [7:0] slv_rx_data,
    output logic       done
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        START,
        DATA,
        STOP
    } spi_state_e;

    spi_state_e state;

    logic sclk_ff1, sclk_ff2, sclk_posedge, sclk_negedge;
    logic cs_n_ff1, cs_n_ff2, start;
    logic [7:0] tx_shift_reg, rx_shift_reg;
    logic [2:0] bit_cnt;
    logic [1:0] mode_reg;

    //edge_deecter
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            sclk_ff1 <= 0;
            sclk_ff2 <= 0;
            cs_n_ff1 <= 0;
            cs_n_ff2 <= 0;
        end else begin
            sclk_ff1 <= sclk;
            sclk_ff2 <= sclk_ff1;
            cs_n_ff1 <= cs_n;
            cs_n_ff2 <= cs_n_ff1;
        end
    end
    assign sclk_posedge = (sclk_ff1 && ~sclk_ff2);
    assign sclk_negedge = (~sclk_ff1 && sclk_ff2);
    assign start        = (~cs_n_ff1 && cs_n_ff2);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            miso         <= 1'b1;
            done         <= 1'b0;
            tx_shift_reg <= 0;
            rx_shift_reg <= 0;
            slv_rx_data  <= 0;
            bit_cnt      <= 0;
            mode_reg     <= 0;
        end else begin
            done <= 1'b0;
            case (state)
                IDLE: begin
                    miso         <= 1'b1;
                    rx_shift_reg <= 0;
                    tx_shift_reg <= 0;
                    mode_reg     <= 0;
                    if (start) begin
                        tx_shift_reg <= slv_tx_data;
                        bit_cnt      <= 0;
                        state        <= START;
                    end
                end
                START: begin
                    miso         <= tx_shift_reg[7];
                    tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
                    state        <= DATA;
                end
                DATA: begin
                    if (bit_cnt == 0) begin
                        if (mode_reg == 0) begin
                            if (sclk_negedge) begin
                                bit_cnt <= bit_cnt + 1;
                                rx_shift_reg <= {rx_shift_reg[6:0], mosi};
                                mode_reg <= 2'd2;
                            end
                            if (sclk_posedge) begin
                                bit_cnt <= bit_cnt + 1;
                                rx_shift_reg <= {rx_shift_reg[6:0], mosi};
                                mode_reg <= 2'd1;
                            end
                        end
                    end else if (bit_cnt < 7) begin
                        if (mode_reg == 1) begin
                            if (sclk_negedge) begin
                                miso         <= tx_shift_reg[7];
                                tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
                            end
                            if (sclk_posedge) begin
                                bit_cnt <= bit_cnt + 1;
                                rx_shift_reg <= {rx_shift_reg[6:0], mosi};
                            end
                        end else begin
                            if (sclk_posedge) begin
                                miso         <= tx_shift_reg[7];
                                tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
                            end
                            if (sclk_negedge) begin
                                bit_cnt <= bit_cnt + 1;
                                rx_shift_reg <= {rx_shift_reg[6:0], mosi};
                            end
                        end
                    end else if (bit_cnt == 7) begin
                        if (mode_reg == 1) begin
                            if (sclk_posedge) begin
                                bit_cnt <= bit_cnt + 1;
                                slv_rx_data <= {rx_shift_reg[6:0], mosi};
                                state <= STOP;
                            end
                            if (sclk_negedge) begin
                                miso         <= tx_shift_reg[7];
                                tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
                            end
                        end else begin
                            if (sclk_negedge) begin
                                bit_cnt <= bit_cnt + 1;
                                slv_rx_data <= {rx_shift_reg[6:0], mosi};
                                state <= STOP;
                            end
                            if (sclk_posedge) begin
                                miso         <= tx_shift_reg[7];
                                tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
                            end
                        end
                    end
                end
                STOP: begin
                    if (sclk_negedge) begin
                        done  <= 1'b1;
                        miso  <= 1'b1;
                        state <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
