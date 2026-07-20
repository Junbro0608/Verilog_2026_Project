`ifndef AGENT_SV
`define AGENT_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "VGA_seq_item.sv"
`include "VGA_driver.sv"
`include "VGA_monitor.sv"


typedef uvm_sequencer#(VGA_seq_item) VGA_sequencer;

class VGA_agent extends uvm_agent;
    `uvm_component_utils(VGA_agent);

    VGA_driver                drv;
    VGA_monitor               mon;
    uvm_sequencer #(VGA_seq_item) sqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = VGA_driver::type_id::create("drv", this);
        mon = VGA_monitor::type_id::create("mon", this);
        sqr = VGA_sequencer::type_id::create("sqr", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction

endclass  //component extends uvm_componet


`endif
