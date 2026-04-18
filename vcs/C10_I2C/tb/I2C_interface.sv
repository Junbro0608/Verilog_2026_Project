`ifndef IF_SV
`define IF_SV

interface I2C_if (
    input logic clk,
    input logic rst
);
    logic       clk;
    logic       rst;
    //-------------master------------
    // command port
    logic       cmd_start;
    logic       cmd_write;
    logic       cmd_read;
    logic       cmd_stop;
    logic [7:0] m_tx_data;
    logic       m_ack_in;
    // internal output
    logic [7:0] m_rx_data;
    logic       m_done;
    logic       m_ack_out;
    logic       m_busy;
    //-------------slave------------
    logic [7:0] s_tx_data;
    logic [7:0] s_rx_data;
    logic       s_ack_in;
    logic       s_busy;
    logic       s_done;

    clocking drv_cb @(posedge clk);
        default input #1step output #0;
        //-------------master------------
        // command port
        output cmd_start;
        output cmd_write;
        output cmd_read;
        output cmd_stop;
        output m_tx_data;
        output m_ack_in;
        // internal output
        input m_rx_data;
        input m_done;
        input m_ack_out;
        input m_busy;
        //-------------slave------------
        output s_tx_data;
        input s_rx_data;
        output s_ack_in;
        input s_busy;
        input s_done;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step;
        // command port
        input cmd_start;
        input cmd_write;
        input cmd_read;
        input cmd_stop;
        input m_tx_data;
        input m_ack_in;
        // internal output
        input m_rx_data;
        input m_done;
        input m_ack_out;
        input m_busy;
        //-------------slave------------
        input s_tx_data;
        input s_rx_data;
        input s_ack_in;
        input s_busy;
        input s_done;
    endclocking

    modport mp_drv(clocking drv_cb, input clk, input rst);
    modport mp_mon(clocking mon_cb, input clk, input rst);
endinterface

`endif
