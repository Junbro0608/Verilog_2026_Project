`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "SPI_ram_seq_item.sv"

class SPI_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(SPI_scoreboard);

    uvm_analysis_imp #(SPI_seq_item, SPI_scoreboard) ap_imp;

    logic [31:0] ref_mem[0:2**6-1];

    int num_writes = 0;
    int num_reads = 0;
    int num_errors = 0;
    logic [31:0] expected;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_imp = new("ap_imp", this);
    endfunction

    virtual function void write(SPI_seq_item tx);
        if (tx.pwrite) begin
            num_writes++;
            ref_mem[tx.paddr>>2] = tx.pwdata;
        end else begin
            num_reads++;
            expected = ref_mem[tx.paddr>>2];
            if (expected !== tx.prdata) begin
                num_errors++;
                `uvm_error(get_type_name(), $sformatf(
                           "FAIL! paddr = 0x%02h, exptected=0x%08h, prdata=0x%08h",
                           tx.paddr,
                           expected,
                           tx.prdata
                           ));
            end else begin
                `uvm_info(get_type_name(), $sformatf(
                          "PASS! paddr = 0x%02h, exptected=0x%08h, prdata=0x%08h",
                          tx.paddr,
                          expected,
                          tx.prdata
                          ), UVM_MEDIUM);
            end
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
