`ifndef MONITOR_SV
`define MONITOR_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
// `include "ram_interface.sv"
`include "SPI_ram_seq_item.sv"


class SPI_monitor extends uvm_monitor;
    `uvm_component_utils(SPI_monitor);

    virtual SPI_if vif;

    uvm_analysis_port #(SPI_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual SPI_if)::get(this, "", "vif", vif))
            `uvm_fatal(get_type_name(), "monitor에서 uvm_config_db 에러 발생");
    endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "SPI 버스 모니터링 시작 ...", UVM_MEDIUM)

        forever begin
            collect_transaction();
        end
    endtask

    task collect_transaction();
        SPI_seq_item tx;

        @(vif.mon_cb);

        if (vif.mon_cb.psel && vif.mon_cb.penable && vif.mon_cb.pready) begin
            tx         = SPI_seq_item::type_id::create("mon_tx");

            tx.paddr   = vif.mon_cb.paddr;
            tx.pwrite  = vif.mon_cb.pwrite;
            tx.pwdata  = vif.mon_cb.pwdata;
            tx.prdata  = vif.mon_cb.prdata;
            tx.pready  = vif.mon_cb.pready;
            tx.penable = vif.mon_cb.penable;
            tx.psel    = vif.mon_cb.psel;
            `uvm_info(get_type_name(), $sformatf("mon tx: %s", tx.convert2string()), UVM_MEDIUM);

            ap.write(tx);
        end
    endtask

endclass  //component extends uvm_componet


`endif
