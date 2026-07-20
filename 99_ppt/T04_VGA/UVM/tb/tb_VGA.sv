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

module tb_VGA ();
    logic clk;
    logic rst;
    initial clk = 0;
    always #5 clk = ~clk;

    VGA_if vif (
        clk,
        rst
    );

    //DUT
    top_slave U_top_slave (
        .clk         (clk),
        .reset       (rst),
        .led         (),
        // ov7670
        .ov7670_pclk (vif.pclk),
        .xclk        (vif.xclk),
        .href        (vif.href),
        .ov7670_vsync(vif.vsync),
        .pdata       (vif.pdata),
        .scl         (),
        .sda         (),
        // VGA 
        .port_red    (vif.port_red),
        .port_green  (vif.port_green),
        .port_blue   (vif.port_blue),
        .h_sync      (vif.h_sync),
        .v_sync      (vif.v_sync),
        // spi slave
        .spi_sclk    (),
        .spi_mosi    (),
        .spi_cs_n    (),
        .spi_miso    (),
        // i2c slave
        .scl_s       (vif.scl_s),
        .sda_s       (vif.sda_s)
    );

    initial begin
        clk = 0;
        rst = 1;
        repeat (5) @(posedge clk);
        rst = 0;
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
