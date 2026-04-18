`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "I2C_interface.sv"
`include "I2C_seq_item.sv"
`include "I2C_sequence.sv"
`include "I2C_driver.sv"
`include "I2C_monitor.sv"
`include "I2C_agent.sv"
`include "I2C_scoreboard.sv"
`include "I2C_coverage.sv"
`include "I2C_env.sv"
`include "I2C_test.sv"

module tb_I2C ();
    logic clk;
    logic rst;
    initial clk = 0;
    always #5 clk = ~clk;

    logic scl;
    wire  sda;

    pullup (vif.sda);
    pullup (vif.scl);

    I2C_if vif (
        clk,
        rst
    );

    I2C_Master U_MASTER (
        .clk      (clk),
        .rst      (rst),
        // command port
        .cmd_start(vif.cmd_start),
        .cmd_write(vif.cmd_write),
        .cmd_read (vif.cmd_read),
        .cmd_stop (vif.cmd_stop),
        .tx_data  (vif.m_tx_data),
        .ack_in   (vif.m_ack_in),
        // internal output
        .rx_data  (vif.m_rx_data),
        .done     (vif.m_done),
        .ack_out  (vif.m_ack_out),
        .busy     (vif.m_busy),
        // external port
        .scl      (scl),
        .sda      (sda)
    );

    i2c_salve #(
        .SLA(7'h12)
    ) U_SLAVE (
        .clk    (clk),
        .rst    (rst),
        // i2c port
        .scl    (scl),
        .sda    (sda),
        // external port
        .tx_data(vif.s_tx_data),
        .rx_data(vif.s_rx_data),
        .ack_in (vif.s_ack_in),
        .busy   (vif.s_busy),
        .done   (vif.s_done)
    );

    //DUT

    initial begin
        clk = 0;
        rst = 1;
        repeat (5) @(posedge clk);
        rst = 0;
    end

    initial begin
        uvm_config_db#(virtual I2C_if)::set(null, "*", "vif", vif);
        run_test();
    end

    initial begin
        $timeformat(-9, 3, " ns");
        $fsdbDumpfile("novas.fsdb");
        $fsdbDumpvars(0, tb_I2C, "+all");
    end
endmodule
