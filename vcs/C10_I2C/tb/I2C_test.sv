`ifndef TEST_SV
`define TEST_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

class I2C_base_test extends uvm_test;
    `uvm_component_utils(I2C_base_test);

    I2C_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = I2C_env::type_id::create("env", this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info(get_type_name(), "===== UVM 계층 구조 =====", UVM_MEDIUM)
        uvm_top.print_topology();
    endfunction


    virtual task run_phase(uvm_phase phase);
    endtask

    virtual task run_test_seq();
        // 자식 클래스에서 해당 기능 구현
    endtask

endclass

class I2C_write_read extends I2C_base_test;
    `uvm_component_utils(I2C_write_read);

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction  //new()

    virtual task run_phase(uvm_phase phase);
        I2C_write_read_seq seq;
        phase.raise_objection(this);
        seq = I2C_write_read_seq::type_id::create("seq");
        seq.num_loop = 10;
        seq.start(env.agt.sqr);
        phase.drop_objection(this);
    endtask

    virtual task run_test_seq();
        // 자식 클래스에서 해당 기능 구현
    endtask

endclass


`endif
