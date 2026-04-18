`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "I2C_ram_seq_item.sv"

class I2C_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(I2C_scoreboard);

    uvm_analysis_imp #(I2C_seq_item, I2C_scoreboard) ap_imp;

    int num_addr_target = 0;
    int num_writes = 0;
    int num_reads = 0;
    int num_errors = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_imp = new("ap_imp", this);
    endfunction

    virtual function void write(I2C_seq_item tr);
        if (tr.addr != 7'h12) begin
        end else begin
            if (tr.m_read) begin
                num_reads++;
            end else begin
                num_writes++;
            end
        end
        if (tr.addr[] !== tr.prdata) begin
            num_errors++;
            `uvm_error(get_type_name(), $sformatf(
                       "FAIL! paddr = 0x%02h, exptected=0x%08h, prdata=0x%08h",
                       tr.paddr,
                       expected,
                       tr.prdata
                       ));
        end else begin
            `uvm_info(get_type_name(), $sformatf(
                      "PASS! paddr = 0x%02h, exptected=0x%08h, prdata=0x%08h",
                      tr.paddr,
                      expected,
                      tr.prdata
                      ), UVM_MEDIUM);
        end
    endfunction

    virtual function void report_phase(uvm_phase phase);
        string result = (num_errors == 0) ? "** PASS **" : "** FAIL **";

        super.report_phase(phase);
        `uvm_info(get_type_name(), $sformatf("\
        \n===== Summary Report =========\
        \n  Result      : %s\
        \n  write num   : %0d\
        \n  read num    : %0d\
        \n  error num   : %0d\
        \n==============================", result, num_writes, num_reads, num_errors), UVM_LOW);
    endfunction

endclass  //component extends uvm_componet


`endif
