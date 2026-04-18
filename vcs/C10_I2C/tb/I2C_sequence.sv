`ifndef SEQUENCE_SV
`define SEQUENCE_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "I2C_ram_seq_item.sv"

class I2C_base_seq extends uvm_sequence #(I2C_seq_item);
    `uvm_object_utils(I2C_base_seq);
    int num_loop = 0;

    function new(string name = "I2C_base_seq");
        super.new(name);
    endfunction  //new()

    task defin_func(bit [7:0] addr, bit [31:0] data);
        I2C_seq_item item;
        item = I2C_seq_item::type_id::create("item");
        start_item(item);
        finish_item(item);
    endtask


    virtual task body();
    endtask

endclass

class I2C_write_read_seq extends I2C_base_seq;
    `uvm_object_utils(I2C_write_read_seq);
    int num_loop = 0;
    bit [7:0] addr;
    bit [31:0] wdata, rdata;

    function new(string name = "I2C_write_read_seq");
        super.new(name);
    endfunction  //new()

    virtual task body();
        I2C_seq_item item = I2C_seq_item::type_id::create("item");
        defin_func(addr, wdata);
    endtask

endclass

`endif
