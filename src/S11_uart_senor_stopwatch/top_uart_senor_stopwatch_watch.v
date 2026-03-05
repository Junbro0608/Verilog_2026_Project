`timescale 1ns / 1ps

module top_uart_senor_stopwatch_watch (
    input        clk,
    input        rst,
    input        btn_r,
    input        btn_l,
    input        btn_u,
    input        btn_d,
    input  [3:0] sw,
    input        uart_rx,
    input        echo,
    inout        dhtio,
    output       trigger,
    output [3:0] fnd_digit,
    output [7:0] fnd_data,
    output [2:0] led,
    output       uart_tx
);
    wire w_b_tick, w_rx_done, w_rx_clear, w_rx_run_stop, w_rx_up, w_rx_down, w_rx_send_start,w_push_mode,w_rx_fnd_sel,w_rx_mode, w_sel_display;
    wire tx_busy, tx_done, w_send_done;
    wire [7:0] w_rx_data, w_send_data;
    wire w_bd_l, w_bd_r, w_bd_d, w_bd_u;
    wire w_c_run_stop, w_c_down_up;
    wire w_c_sr04_start, w_c_sr04_auto;
    wire [1:0] w_c_mode;
    wire [1:0] w_c_clear, w_c_time_modify;
    wire [27:0] w_dht11_data, w_sr04_data, w_dp_stopwatch_time, w_dp_watch_time, w_select_data;
    wire [31:0] w_fnd_data;
    //----------------Uart-------------------------
    //-----------------tx------------------------------------
    baud_tick U_BAUD_TICK (
        .clk   (clk),
        .rst   (rst),
        .b_tick(w_b_tick)
    );

    uart_tx U_UART_TX (
        .clk     (clk),
        .rst     (rst),
        .tx_start(w_send_done),
        .b_tick  (w_b_tick),
        .tx_data (w_send_data),
        .tx_busy (w_tx_busy),
        .tx_done (tx_done),
        .uart_tx (uart_tx)
    );

    tx_sender #(
        .SEND_DATA_WITCH(8)
    ) U_SENDER (
        .clk          (clk),
        .rst          (rst),
        .send_start   (w_rx_send_start),
        .i_sender_data(w_fnd_data),
        .i_tx_busy    (w_tx_busy),
        .i_tx_done    (tx_done),
        .o_send_data  (w_send_data),
        .o_send_done  (w_send_done)
    );


    //-----------------rx------------------------------------
    uart_rx U_UART_RX (
        .clk    (clk),
        .rst    (rst),
        .rx     (uart_rx),
        .b_tick (w_b_tick),
        .rx_data(w_rx_data),
        .rx_done(w_rx_done)
    );
    rx_decoder U_RX_DEACODER (
        .clk         (clk),
        .rst         (rst),
        .i_rx_data   (w_rx_data),
        .i_rx_done   (w_rx_done),
        .o_clear     (w_rx_clear),
        .o_run_stop  (w_rx_run_stop),
        .o_up        (w_rx_up),
        .o_down      (w_rx_down),
        .o_send_start(w_rx_send_start),
        .o_mode      (w_rx_mode),
        .o_fnd_sel   (w_rx_fnd_sel)
    );
    //------------------------sw_changer---------------------
    push_change U_PUSH_FND (
        .clk  (clk),
        .rst  (rst),
        .d_in (sw[3]),
        .push (w_rx_fnd_sel),
        .d_out(w_sel_display)
    );
    //-----------------btn_debounce------------------------
    btn_debounce U_BD_CLEAR (
        .clk  (clk),
        .reset(rst),
        .i_btn(btn_l),
        .o_btn(w_bd_l)
    );
    btn_debounce U_BD_RUNSTOP (
        .clk  (clk),
        .reset(rst),
        .i_btn(btn_r),
        .o_btn(w_bd_r)
    );
    btn_debounce U_BD_UP (
        .clk  (clk),
        .reset(rst),
        .i_btn(btn_u),
        .o_btn(w_bd_u)
    );
    btn_debounce U_BD_DOWN (
        .clk  (clk),
        .reset(rst),
        .i_btn(btn_d),
        .o_btn(w_bd_d)
    );
    //-----------------control_unit------------------------
    control_unit U_CTLR_UNIT (
        .clk          (clk),
        .rst          (rst),
        .i_btn_l      (w_bd_l),
        .i_btn_r      (w_bd_r),
        .i_btn_u      (w_bd_u),
        .i_btn_d      (w_bd_d),
        .i_mode       (sw[1:0]),
        .i_sw_up_down (sw[2]),
        .o_clear      (w_c_clear),
        .o_run_stop   (w_c_run_stop),
        .o_down_up    (w_c_down_up),
        .o_time_modify(w_c_time_modify),
        .o_sr04_auto  (w_c_sr04_auto),
        .o_sr04_start (w_c_sr04_start),
        .o_mode       (w_c_mode),
        .test_mode    (led)
    );
    //-----------------datapath------------------------
    datapath_stopwatch U_DP_STOPWATCH (
        .clk             (clk),
        .reset           (rst),
        .i_clear         (w_c_clear[0]),
        .i_down_up       (w_c_down_up),
        .i_run_stop      (w_c_run_stop),
        .o_stopwatch_time(w_dp_stopwatch_time)
    );
    datapath_watch U_DP_WATCH (
        .clk          (clk),
        .reset        (rst),
        .i_clear      (w_c_clear[1]),
        .i_time_modify(w_c_time_modify),
        .o_watch_time (w_dp_watch_time)
    );
    //-----------------sensor------------------------
    top_sr04 U_SR04_CTRL (
        .clk        (clk),
        .rst        (rst),
        .start      (w_c_sr04_start),
        .echo       (echo),
        .trigger    (trigger),
        .o_dist_sr04(w_sr04_data)
    );
    dht11_controller U_DHT11_CTRL (
        .clk        (clk),
        .rst        (rst),
        .start      (),
        .humidity   (w_dht11_data[27:14]),
        .temperature(w_dht11_data[13:0]),
        .dht11_done (),
        .dht11_valid(),
        .debug      (),
        .dhtio      (dhtio)
    );
    //-----------------mux4x1------------------------
    assign w_dp_select_time = (w_c_mode == 2'd0)? w_dp_stopwatch_time:
                              (w_c_mode == 2'd1)? w_dp_watch_time:
                              (w_c_mode == 2'd2)? w_sr04_data:
                                                  w_dht11_data;
    //-----------------fnd_ctlr------------------------
    fnd_controller U_FND_CNTL (
        .clk        (clk),
        .reset      (rst),
        .sel_display(w_sel_display),
        .fnd_in_data(w_dp_select_time),
        .send_data  (w_fnd_data),
        .fnd_digit  (fnd_digit),
        .fnd_data   (fnd_data)
    );
endmodule
