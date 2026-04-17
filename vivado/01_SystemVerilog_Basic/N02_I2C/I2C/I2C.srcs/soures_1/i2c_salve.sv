module i2c_salve #(
    parameter SLA = 7'h12
) (
    input              clk,
    input              rst,
    // i2c port
    input              scl,
    inout  logic       sda,
    // external port
    input        [7:0] tx_data,
    input              ack_in,
    output logic [7:0] rx_data,
    output logic       busy,
    output logic       done
);

    typedef enum logic [2:0] {
        IDLE       = 3'b0,
        ADDR,
        ADDR_ACK,
        WAIT_DATA,
        DATA,
        DATA_ACK,
        CHECK_NACK,
        STOP
    } i2c_state_e;

    logic scl_ff1, scl_ff2, scl_posedge, scl_negedge;
    i2c_state_e state;
    logic [2:0] bit_cnt;
    logic is_m_read, sda_r;
    logic [7:0] tx_shift_reg, rx_shift_reg;

    assign sda  = (sda_r) ? 1'b0 : 1'bz;
    assign busy = (state != IDLE);

    always_ff @(posedge clk or posedge rst) begin : blockName
        if (rst) begin
            scl_ff1 <= 1'b0;
            scl_ff2 <= 1'b0;
        end else begin
            scl_ff1 <= scl;
            scl_ff2 <= scl_ff1;
        end
    end
    assign scl_posedge = (scl_ff1 & ~scl_ff2);
    assign scl_negedge = (~scl_ff1 & scl_ff2);

    always_ff @(posedge clk or posedge rst) begin : i2c_salve
        if (rst) begin
            state <= IDLE;
            sda_r <= 0;
            is_m_read <= 0;
            bit_cnt <= 0;
            rx_shift_reg <= 0;
            tx_shift_reg <= 0;
        end else begin
            done <= 1'b0;
            case (state)
                IDLE: begin
                    if (!scl) begin
                        tx_shift_reg <= 0;
                        rx_shift_reg <= 0;
                        state        <= ADDR;
                        sda_r        <= 1'b0;
                    end
                end
                ADDR: begin
                    if (scl_posedge) begin
                        // ADDR read
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt < 7) begin
                            rx_shift_reg <= {rx_shift_reg[6:0], sda};
                            // Check Write,Read
                        end else if (bit_cnt == 7) begin
                            bit_cnt <= 0;
                            state   <= ADDR_ACK;
                            if (!sda) begin  // master is writing
                                is_m_read <= 1'b0;
                            end else begin  // master is reading
                                is_m_read <= 1'b1;
                            end
                        end
                    end
                end
                ADDR_ACK: begin
                    if (scl_posedge) begin
                        // Check Addr
                        if (rx_shift_reg == SLA) begin
                            sda_r <= 1'b1;
                            if (is_m_read) begin
                                done <= 1'b1;
                            end
                            state <= WAIT_DATA;
                        end else begin
                            state <= IDLE;
                        end
                    end
                end
                WAIT_DATA: begin
                    rx_shift_reg <= 0;
                    tx_shift_reg <= tx_data;
                    state        <= DATA;

                    sda_r        <= (is_m_read) ? ~(tx_data[7]) : 1'b0;
                end
                DATA: begin
                    if (scl_posedge) begin
                        if (is_m_read) begin  // master is reading
                            sda_r        <= ~(tx_shift_reg[7]);
                            tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
                        end else begin  // master is writing
                            sda_r <= 1'b0;
                            rx_shift_reg <= {rx_shift_reg[6:0], sda};
                        end
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt == 7) begin
                            bit_cnt <= 0;
                            rx_data <= {rx_shift_reg[6:0], sda};
                            state   <= DATA_ACK;
                        end
                    end
                end
                DATA_ACK: begin
                    if (scl_posedge) begin
                        if (!is_m_read) begin  //master is writing
                            sda_r <= 1'b1;
                        end else begin  //master is reading
                            sda_r <= 1'b0;
                        end
                    end
                    if (scl_negedge) begin
                        state <= CHECK_NACK;
                        if (!is_m_read) begin  //master is writing
                            sda_r <= ack_in;
                        end else begin  //master is reading
                            sda_r <= 1'b0;
                        end
                        state <= CHECK_NACK;
                    end
                end
                CHECK_NACK: begin
                    if (scl_posedge) begin
                        if (!is_m_read) begin  //master is reading
                            state <= (sda_r) ? WAIT_DATA : STOP;
                            done  <= (sda_r);
                        end else begin  // master is reading
                            state <= (sda) ? WAIT_DATA : STOP;
                            done  <= (sda);
                        end
                    end
                end
                STOP: begin
                    if (scl_posedge) begin
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
