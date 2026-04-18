`ifndef MONITOR_SV
`define MONITOR_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
// `include "ram_interface.sv"
`include "I2C_ram_seq_item.sv"


class I2C_monitor extends uvm_monitor;
    `uvm_component_utils(I2C_monitor);

    virtual I2C_if vif;

    uvm_analysis_port #(I2C_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual I2C_if)::get(this, "", "vif", vif))
            `uvm_fatal(get_type_name(), "monitor에서 uvm_config_db 에러 발생");
    endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "I2C 버스 모니터링 시작 ...", UVM_MEDIUM)
        forever begin
            collect_transaction();
        end
    endtask

    task collect_transaction();
        I2C_seq_item tr;

        @(vif.mon_cb);

        tr = I2C_seq_item::type_id::create("mon_tr");
        wait (vif.mon_cb.cmd_start);
        wait (vif.mon_cb.cmd_write);
        repeat (5) @(vif.mob_cb);
        tr.addr   = vif.mon_cb.tx_data[7:1];
        tr.m_read = vif.mon_cb.tx_data[0];
        wait (vif.mon_cb.m_done);
        repeat (5) @(vif.mob_cb);

        //send_scb
        if (tr.m_read) begin
            wait (vif.mon_cb.m_done);
            tr.mon_cb.m_tx_data = vif.mon_cb.m_tx_data;
            tr.mon_cb.s_rx_data = vif.mon_cb.s_rx_data;
        end else begin
            wait (vif.mon_cb.s_done);
            tr.mon_cb.m_rx_data = vif.mon_cb.m_rx_data;
            tr.mon_cb.s_tx_data = vif.mon_cb.s_tx_data;
        end

        `uvm_info(get_type_name(), $sformatf("mon tr: %s", tr.convert2string()), UVM_MEDIUM);

        ap.write(tr);
    endtask

endclass  //component extends uvm_componet


`endif
