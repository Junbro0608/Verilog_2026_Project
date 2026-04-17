module battery_ctrl (
    input              clk,
    input              rst,
    //uesr
    input              start,
    output logic [7:0] soc_data,
    //SPI interface
    input        [7:0] rx_data,
    input              done,
    output logic       ack_in,
    output logic [7:0] tx_data,
    output logic       cmd_start,
    output logic       cmd_write,
    output logic       cmd_read,
    output logic       cmd_stop
);

    typedef enum logic [2:0] {
        IDLE = 0,
        START,
        ADDR,
        WRITE,
        READ,
        STOP
    } i2c_state_e;

    i2c_state_e state;
    logic       s_interrupt;
    logic [7:0] rx_soc_int, rx_soc_dec;
    parameter SLA_W = {7'h12, 1'b0};

    // start register
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            s_interrupt <= 1'b0;
        end else begin
            if (start) begin
                s_interrupt <= 1'b1;
            end
        end
    end

    always_ff @(posedge clk or posedge rst) begin : blockName
        if (rst) begin
            soc_data <= 0;
        end else begin
            if (state == STOP) begin
                soc_data <= (rx_soc_int * 100) + rx_soc_dec;
            end
        end
    end

    //FSM
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            cmd_start <= 1'b0;
            cmd_write <= 1'b0;
            cmd_read  <= 1'b0;
            cmd_stop  <= 1'b0;
            tx_data   <= 8'b0;
            ack_in    <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    cmd_start <= 1'b0;
                    cmd_write <= 1'b0;
                    cmd_read  <= 1'b0;
                    cmd_stop  <= 1'b0;
                    if (start) begin
                        state <= START;
                    end
                end
                START: begin
                    cmd_start <= 1'b1;
                    cmd_write <= 1'b0;
                    cmd_read  <= 1'b0;
                    cmd_stop  <= 1'b0;
                    if (done) begin
                        state <= ADDR;
                    end
                end
                ADDR: begin
                    cmd_start <= 1'b0;
                    cmd_write <= 1'b1;
                    cmd_read  <= 1'b0;
                    cmd_stop  <= 1'b0;
                    tx_data   <= SLA_W;
                    if (done) begin
                        if (s_interrupt) begin
                            state <= WRITE;
                            s_interrupt <= 0;
                        end else begin
                            state <= READ;
                        end
                    end
                end
                WRITE: begin
                    cmd_start <= 1'b0;
                    cmd_write <= 1'b1;
                    cmd_read  <= 1'b0;
                    cmd_stop  <= 1'b0;
                    tx_data   <= 8'b1;
                    if (done) begin
                        state <= STOP;
                    end
                end
                READ: begin
                    cmd_start <= 1'b0;
                    cmd_write <= 1'b0;
                    cmd_read  <= 1'b1;
                    cmd_stop  <= 1'b0;
                    tx_data   <= 8'b0;
                    if (done) begin
                        rx_soc_int <= rx_data;
                        state <= STOP;
                    end
                end
                STOP: begin
                    cmd_start <= 1'b0;
                    cmd_write <= 1'b0;
                    cmd_read  <= 1'b0;
                    cmd_stop  <= 1'b1;
                    if (done) begin
                        ack_in <= 1'b1;
                        state  <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
