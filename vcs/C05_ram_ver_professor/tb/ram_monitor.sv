`ifndef RAM_MONITOR_SV
`define RAM_MONITOR_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
// `include "ram_interface.sv"
`include "ram_seq_item.sv"


class ram_monitor extends uvm_monitor;
    `uvm_component_utils(ram_monitor);

    virtual ram_if r_if;

    uvm_analysis_port #(ram_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual ram_if)::get(this, "", "r_if", r_if))
            `uvm_fatal(get_type_name(), "ram interface를 config_db에서 가져올 수 없음");
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            ram_seq_item item = ram_seq_item::type_id::create("item");
            @(r_if.mon_cb);
            item.write = r_if.mon_cb.write;
            item.addr  = r_if.mon_cb.addr;
            item.wdata = r_if.mon_cb.wdata;
            if (!item.write) begin
                @(r_if.mon_cb);
                item.rdata = r_if.mon_cb.rdata;
            end
            ap.write(item);
            `uvm_info(get_type_name(), $sformatf("push =>%s", item.convert2string()), UVM_MEDIUM);
        end
    endtask

endclass  //component extends uvm_componet


`endif
