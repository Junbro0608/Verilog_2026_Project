`ifndef COVERAGE_SV
`define COVERAGE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "I2C_ram_seq_item.sv"

class I2C_coverage extends uvm_subscriber #(I2C_seq_item);
    `uvm_component_utils(I2C_coverage);

    I2C_seq_item tx;

    covergroup I2C_cg;
        cp_addr: coverpoint tx.paddr {
            bins addr_low = {[8'h00 : 8'h3c]};
            bins addr_mid_low = {[8'h40 : 8'h7c]};
            bins addr_mid_high = {[8'h80 : 8'h8c]};
            bins addr_high = {[8'hc0 : 8'hcf]};
        }
        cp_rw: coverpoint tx.pwrite {bins write_op = {1}; bins read_op = {0};}
        cp_wdata: coverpoint tx.pwdata {
            bins all_zeros = {32'h0000_0000};
            bins all_ones = {32'hffff_ffff};
            bins all_a = {32'haaaa_aaaa};
            bins all_5 = {32'h5555_5555};
            bins other = default;
        }
        cp_rdata: coverpoint tx.prdata {
            bins all_zeros = {32'h0000_0000};
            bins all_ones = {32'hffff_ffff};
            bins all_a = {32'haaaa_aaaa};
            bins all_5 = {32'h5555_5555};
            bins other = default;
        }
        cx_addr_rw: cross cp_addr, cp_rw;
    endgroup

    function new(string name = "COV", uvm_component c);
        super.new(name, c);
        I2C_cg = new();
    endfunction  //new()

    virtual function void write(I2C_seq_item t);
        tx = t;
        I2C_cg.sample();
        `uvm_info(get_type_name(), $sformatf("counter_cg sampled: %s", tx.convert2string()),
                  UVM_MEDIUM);
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf(
                  "\
        \n===== Coverage Summary =====\
        \n  addr            : %.1f%%\
        \n  rw              : %.1f%%\
        \n  wdata           : %.1f%%\
        \n  rdata           : %.1f%%\
        \n  cross(addr, rw) : %.1f%%\
        \n============================",
                  I2C_cg.cp_addr.get_coverage(),
                  I2C_cg.cp_rw.get_coverage(),
                  I2C_cg.cp_wdata.get_coverage(),
                  I2C_cg.cp_rdata.get_coverage(),
                  I2C_cg.cx_addr_rw.get_coverage()
                  ), UVM_LOW);
    endfunction
endclass  

`endif
