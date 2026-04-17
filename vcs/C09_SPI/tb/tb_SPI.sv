`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "SPI_interface.sv"
`include "SPI_seq_item.sv"
`include "SPI_sequence.sv"
`include "SPI_driver.sv"
`include "SPI_monitor.sv"
`include "SPI_agent.sv"
`include "SPI_scoreboard.sv"
`include "SPI_coverage.sv"
`include "SPI_env.sv"
`include "SPI_test.sv"

module tb_SPI ();
    logic clk;
    logic rst_n;
    initial pclk = 0;
    always #5 pclk = ~pclk;

    SPI_if vif (
    );

    //DUT

    initial begin
        clk = 0;
        rst_n = 0;
        repeat (5) @(posedge pclk);
        rst_n = 1;
    end
    
    initial begin
        uvm_config_db#(virtual SPI_if)::set(null, "*", "vif", vif);
        run_test();
    end

    initial begin
        $timeformat(-9, 3, " ns");
        $fsdbDumpfile("novas.fsdb");
        $fsdbDumpvars(0, tb_SPI, "+all");
    end
endmodule
