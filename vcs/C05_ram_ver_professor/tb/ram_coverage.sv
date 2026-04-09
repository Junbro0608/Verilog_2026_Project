`ifndef COMPONENT_SV
`define COMPONENT_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

class ram_coverage extends uvm_subscriber #(ram_seq_item);
    `uvm_component_utils(ram_coverage);

    ram_seq_item item;

    covergroup ram_cg;
        cp_write: coverpoint item.write {bins write = {1}; bins read = {0};}
        cp_addr: coverpoint item.addr {
            bins range0_3 = {[8'h0 : 8'h3f]};
            bins range4_7 = {[8'h40 : 8'h7f]};
            bins range8_a = {[8'h80 : 8'haf]};
            bins rangeb_f = {[8'hb0 : 8'hff]};
        }
        cp_wdata: coverpoint item.wdata {
            bins range0_3 = {[16'h0 : 16'h3fff]};
            bins range4_7 = {[16'h4000 : 16'h7fff]};
            bins range8_a = {[16'h8000 : 16'hafff]};
            bins rangeb_f = {[16'hb000 : 16'hffff]};
        }
        cp_rdata: coverpoint item.rdata {
            bins range0_3 = {[16'h0 : 16'h3fff]};
            bins range4_7 = {[16'h4000 : 16'h7fff]};
            bins range8_a = {[16'h8000 : 16'hafff]};
            bins rangeb_f = {[16'hb000 : 16'hffff]};
        }
        //cross coverage
        cx_addr_wdata: cross cp_addr, cp_wdata;
        cx_addr_rdata: cross cp_addr, cp_rdata;
    endgroup

    function new(string name = "COV", uvm_component c);
        super.new(name, c);
        ram_cg = new();
    endfunction  //new()

    virtual function void write(ram_seq_item t);
        item = t;
        ram_cg.sample();
        `uvm_info(get_type_name(), $sformatf("counter_cg sampled: %s", item.convert2string()),
                  UVM_MEDIUM);
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf(
                  "\
        \n===== Coverage Summary =====\
        \n  write               : %.1f%%\
        \n  wdata               : %.1f%%\
        \n  rdata               : %.1f%%\
        \n  cross(addr, wdata)  : %.1f%%\
        \n  cross(addr, rdata)  : %.1f%%\
        \n============================",
                  ram_cg.cp_write.get_coverage(),
                  ram_cg.cp_wdata.get_coverage(),
                  ram_cg.cp_rdata.get_coverage(),
                  ram_cg.cx_addr_wdata.get_coverage(),
                  ram_cg.cx_addr_rdata.get_coverage()
                  ), UVM_LOW);
    endfunction
endclass  //ram_coverage extends uvm_subscriber#(counter_seq_item)

`endif
