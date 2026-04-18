`ifndef DRIVER_SV
`define DRIVER_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "I2C_ram_seq_item.sv"

class I2C_driver extends uvm_driver #(I2C_seq_item);
    `uvm_component_utils(I2C_driver);

    virtual I2C_if vif;

    typedef enum logic [1:0] {
        IDLE = 3'b0,
        ADDR,
        DATA,
        STOP
    } i2c_state_e;
    i2c_state_e state;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual I2C_if)::get(this, "", "vif", vif))
            `uvm_fatal(get_type_name(), "driver에서 uvm_config_db 에러 발생");
    endfunction


    virtual task run_phase(uvm_phase phase);
        I2C_bus_init();
        wait (vif.presetn == 1);
        `uvm_info(get_type_name(), "리셋 해제 확인. 트랜잭션 대기 중 ...", UVM_MEDIUM)

        forever begin
            I2C_seq_item tr;
            seq_item_port.get_next_item(tr);
            drive_I2C(tr);
            seq_item_port.item_done();
        end
    endtask

    task I2C_init();
        state = IDLE;
        cmd_init();
        vif.drv_cb.m_tx_data = 0;
        vif.drv_cb.m_ack_in  = 0;
        //-------------slave------------
        vif.drv_cb.s_tx_data = 0;
        vif.drv_cb.s_ack_in  = 0;
    endtask

    task cmd_init();
        vif.drv_cb.cmd_start = 0;
        vif.drv_cb.cmd_write = 0;
        vif.drv_cb.cmd_read  = 0;
        vif.drv_cb.cmd_stop  = 0;
    endtask

    task drive_I2C(I2C_seq_item tr);
        case (state)
            IDLE: begin
                cmd_init();
                vif.drv_cb.cmd_start = 1;
                wait (vif.drv_cb.m_done);
                state = ADDR;
                @(posedge vif.drv_cb);
            end
            ADDR: begin
                cmd_init();
                vif.drv_cb.cmd_write = 1;
                vif.drv_cb.tx_data   = tr.addr;
                wait (vif.drv_cb.m_done);
                state = DATA;
                @(posedge vif.drv_cb);
            end
            DATA: begin
                cmd_init();
                if (tr.mode == 1) begin
                    vif.drv_cb.cmd_read = 1;
                end else begin
                    vif.drv_cb.cmd_write = 1;
                end
                wait (vif.drv_cb.m_done);
                state = STOP;
                @(posedge vif.drv_cb);
            end
            STOP: begin
                cmd_init();
                vif.drv_cb.stop = 1;
                wait (vif.drv_cb.m_done);
                state = IDLE;
                @(posedge vif.drv_cb);
            end
        endcase


        `uvm_info(get_type_name(), $sformatf("drv I2C 구동 완료: %s", tx.convert2string()),
                  UVM_MEDIUM)
    endtask

endclass  //component extends uvm_componet


`endif
