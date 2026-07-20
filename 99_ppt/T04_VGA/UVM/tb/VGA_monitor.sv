`ifndef MONITOR_SV
`define MONITOR_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "VGA_seq_item.sv"

class VGA_monitor extends uvm_monitor;
    `uvm_component_utils(VGA_monitor)

    virtual VGA_if vif;
    uvm_analysis_port #(VGA_seq_item) ap;

    localparam WIDTH  = 320;
    localparam HEIGHT = 240;
    int frame_cnt = 0;
    VGA_seq_item tx;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual VGA_if)::get(this, "", "vif", vif))
            `uvm_fatal(get_type_name(), "monitor에서 vif를 찾을 수 없습니다.");
    endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "완전 독립형 모니터링 시작...", UVM_LOW)
        
        tx = VGA_seq_item::type_id::create("mon_tx");
        tx.i2c_read_data = 8'h00; 

        // 💡 픽셀 수집과 I2C 수집을 묶지 않고 완전히 독립적인 무한루프로 돌립니다!
        fork
            collect_pixels_and_save();
            collect_i2c_and_send();
        join
    endtask

    // =========================================================
    // [독립 스레드 1] 카메라 픽셀 수집 및 즉시 이미지 저장
    // =========================================================
    task collect_pixels_and_save();
        int pixel_cnt;
        logic [7:0] byte1, byte2;
        string filename;
        int file_id, r, g, b;

        forever begin
            // 프레임 시작 대기
            @(negedge vif.vsync); 
            `uvm_info(get_type_name(), "[모니터] 카메라 프레임 시작! 픽셀 수집 중...", UVM_LOW)

            pixel_cnt = 0;
            while (pixel_cnt < (WIDTH * HEIGHT)) begin
                @(posedge vif.pclk);
                if (vif.href) begin
                    byte1 = vif.pdata;
                    @(posedge vif.pclk);
                    byte2 = vif.pdata;
                    
                    tx.VGA_image[pixel_cnt] = {byte1[7:4], byte1[2:0], byte2[7], byte2[4:1]};
                    pixel_cnt++;
                end
                if (vif.vsync == 1'b1) break; // 비정상 종료 시 탈출
            end

            // 수집 완료 즉시 묻지도 따지지도 않고 이미지 저장!
            if (pixel_cnt == (WIDTH * HEIGHT)) begin
                frame_cnt++;
                filename = $sformatf("./result/captured_frame_%0d.ppm", frame_cnt);
                file_id = $fopen(filename, "w");

                if (file_id) begin
                    $fwrite(file_id, "P3\n%0d %0d\n255\n", WIDTH, HEIGHT);
                    for (int i = 0; i < (WIDTH * HEIGHT); i++) begin
                        r = {tx.VGA_image[i][11:8], tx.VGA_image[i][11:8]};
                        g = {tx.VGA_image[i][7:4],  tx.VGA_image[i][7:4]};
                        b = {tx.VGA_image[i][3:0],  tx.VGA_image[i][3:0]};
                        $fwrite(file_id, "%0d %0d %0d\n", r, g, b);
                    end
                    $fclose(file_id);
                    `uvm_info(get_type_name(), $sformatf("이미지 저장 완료 (I2C와 무관하게 성공!): %s", filename), UVM_LOW)
                end
            end
        end
    endtask

    // =========================================================
    // [독립 스레드 2] I2C 캡처 및 스코어보드 전송
    // =========================================================
    task collect_i2c_and_send();
        bit [6:0] addr;
        bit       rw;
        bit [7:0] rdata;

        forever begin
            @(negedge vif.sda_s iff vif.scl_s === 1'b1); 
            addr = 7'b0;
            for (int i = 0; i < 7; i++) begin
                @(posedge vif.scl_s);
                addr = {addr[5:0], vif.sda_s};
            end
            @(posedge vif.scl_s);
            rw = vif.sda_s;
            @(posedge vif.scl_s); 

            if (addr == 7'h10 && rw == 1'b1) begin
                rdata = 8'b0;
                for (int i = 0; i < 8; i++) begin
                    @(posedge vif.scl_s);
                    rdata = {rdata[6:0], vif.sda_s};
                end
                @(posedge vif.scl_s); 
                @(posedge vif.sda_s iff vif.scl_s === 1'b1); 

                tx.i2c_read_data = rdata;
                `uvm_info(get_type_name(), $sformatf("I2C 캡처 성공! [Data: 2'b%02b]. 스코어보드로 넘깁니다.", rdata[1:0]), UVM_LOW)
                
                // 💡 I2C까지 성공적으로 들어왔을 때만 스코어보드 채점 시작!
                ap.write(tx); 
            end
        end
    endtask

endclass
`endif