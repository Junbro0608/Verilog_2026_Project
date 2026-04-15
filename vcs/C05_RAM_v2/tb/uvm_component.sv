`ifndef COMPONENT_SV
`define COMPONENT_SV

`timescale  1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

class component extends uvm_componet;
    `uvm_componet_utils(component);

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        
    endfunction

    virtual task run_phase(uvm_phase phase);
    
    endtask

    virtual function void report_phase(uvm_phase phase);
        
    endfunction

endclass //component extends uvm_componet


`endif
