`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "VGA_interface.sv"
`include "VGA_seq_item.sv"
`include "VGA_sequence.sv"
`include "VGA_driver.sv"
`include "VGA_monitor.sv"
`include "VGA_agent.sv"
`include "VGA_scoreboard.sv"
`include "VGA_coverage.sv"
`include "VGA_env.sv"
`include "VGA_test.sv"

module tb_apb ();
    logic clk;
    logic rst_n;
    initial pclk = 0;
    always #5 pclk = ~pclk;

    VGA_if vif (
    );

    //DUT

    initial begin
        clk = 0;
        rst_n = 0;
        repeat (5) @(posedge pclk);
        rst_n = 1;
    end
    
    initial begin
        uvm_config_db#(virtual VGA_if)::set(null, "*", "vif", vif);
        run_test();
    end

    initial begin
        $timeformat(-9, 3, " ns");
        $fsdbDumpfile("novas.fsdb");
        $fsdbDumpvars(0, tb_VGA, "+all");
    end
endmodule
