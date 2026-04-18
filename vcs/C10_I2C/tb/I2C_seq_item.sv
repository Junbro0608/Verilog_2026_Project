`ifndef SEQ_ITEM_SV
`define SEQ_ITEM_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class I2C_seq_item extends uvm_sequence_item;
    //-------------master------------
    // command port
    logic             cmd_start;
    logic             cmd_write;
    logic             cmd_read;
    logic             cmd_stop;
    randc logic [7:0] m_tx_data;
    logic             m_ack_in;
    // internal output
    logic       [7:0] m_rx_data;
    logic             m_done;
    logic             m_ack_out;
    logic             m_busy;
    //-------------slave------------
    randc logic [7:0] s_tx_data;
    logic       [7:0] s_rx_data;
    logic             s_ack_in;
    logic             s_busy;
    logic             s_done;
    //----------local---------------
    logic             m_read;
    rand logic  [6:0] addr;
    // constraint c_addr_dist { 
    // addr dist {
    //     12         := 70, 
    //     [ 0 :  11] :/ 30,
    //     };
    // }

    // constraint c_one_hot_cmd {
    //     $countones({cmd_start, cmd_write, cmd_read, cmd_stop}) <= 1;
    // }

    `uvm_object_utils_begin(I2C_seq_item)
    //-------------master------------
    // command port
        `uvm_field_int(cmd_start, UVM_ALL_ON)
        `uvm_field_int(cmd_write, UVM_ALL_ON)
        `uvm_field_int(cmd_read, UVM_ALL_ON)
        `uvm_field_int(cmd_stop, UVM_ALL_ON)
        `uvm_field_int(m_tx_data, UVM_ALL_ON)
        `uvm_field_int(m_ack_in, UVM_ALL_ON)
    // internal output
        `uvm_field_int(m_rx_data, UVM_ALL_ON)
        `uvm_field_int(m_done, UVM_ALL_ON)
        `uvm_field_int(m_ack_out, UVM_ALL_ON)
        `uvm_field_int(m_busy, UVM_ALL_ON)
    //-------------slave------------
        `uvm_field_int(s_tx_data, UVM_ALL_ON)
        `uvm_field_int(s_rx_data, UVM_ALL_ON)
        `uvm_field_int(s_ack_in, UVM_ALL_ON)
        `uvm_field_int(s_busy, UVM_ALL_ON)
        `uvm_field_int(s_done, UVM_ALL_ON)
    `uvm_object_utils_end


    function new(string name = "I2C_seq_item");
        super.new(name);
    endfunction  //new()

    function string convert2string();
        string op = (cmd_start) ? "START" :
                    (cmd_write) ? "WRITE" :
                    (cmd_read) ?  "READ" :
                    (cmd_stop) ? "STOP" :
                    "NONE";
        return $sformatf(
            "\ncmd_%s[%s]addr=0x%02h\
            \tMaster m_tx_data=0x%02h, m_ack_out=%01b, m_busy=%01b\
            \ts_tx_data=0x%02h, s_rx_data=0x%02h, s_ack_in=%01b s_busy=%01b s_done=%01b",
            op,
            m_write,
            addr,
            m_tx_data,
            m_ack_out,
            m_busy,
            s_tx_data,
            s_rx_data,
            s_ack_in,
            s_busy,
            s_done
        );
    endfunction

endclass  //component extends uvm_componet


`endif
