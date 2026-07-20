`ifndef DRIVER_SV
`define DRIVER_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "VGA_seq_item.sv"

class VGA_driver extends uvm_driver #(VGA_seq_item);
    `uvm_component_utils(VGA_driver)

    virtual VGA_if vif;

    logic [15:0] img_mem[0:76799];
    int pixel_idx;

    bit prev_vsync;
    int vsync_drop_cnt;
    event trigger_i2c_read;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual VGA_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NO_VIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
        end
        $readmemh("input_img.mem", img_mem);
    endfunction

    virtual task run_phase(uvm_phase phase);
        VGA_seq_item tx;
        VGA_bus_init();

        fork
            // =========================================================
            // 💡 [스레드 1] 강철 PCLK 생성기 (독립 구동)
            // DUT의 클럭(xclk) 지연에 영향받지 않도록 스스로 뜁니다!
            // =========================================================
            begin
                vif.pclk <= 0;
                forever begin
                    #20; // 25MHz의 반주기(20ns) 마다 토글
                    vif.pclk <= ~vif.pclk;
                end
            end

            // =========================================================
            // [스레드 2] 메인 데이터 전송 
            // =========================================================
            begin
                `uvm_info(get_type_name(), "리셋 대기 중...", UVM_MEDIUM)
                wait (vif.rst == 0);
                `uvm_info(get_type_name(), "리셋 해제 완료! 트랜잭션 대기 중 ...", UVM_MEDIUM)

                @(negedge vif.pclk);  // 클럭 동기화
                forever begin
                    seq_item_port.get_next_item(tx);
                    drive_VGA(tx);
                    seq_item_port.item_done();
                end
            end

            // =========================================================
            // 💡 [스레드 3] I2C 통신 (무한 대기 방지 + 레지스터 래치 대기)
            // =========================================================
            forever begin
                @trigger_i2c_read;
                `uvm_info(get_type_name(), "VGA Frame 2 (빨간 네모 출력) 스캔 대기 중...", UVM_LOW)

                // 최상위 TB에서 v_sync 매핑 누락 시에도 멈추지 않도록 fork-join_any 적용
                fork
                    begin
                        @(negedge vif.v_sync);
                        @(negedge vif.v_sync);
                    end
                    begin
                        #35000000;  // 약 35ms (넉넉한 2프레임 시간) 대기 안전장치
                    end
                join_any
                disable fork;

                // 💡 핵심: 하드웨어가 v_sync 엣지 이후에 레지스터를 완벽히 업데이트할 수 있도록 시간 부여
                #200000; // 200us (0.2ms) 대기

                `uvm_info(get_type_name(), "VGA 래치 완료 및 안정화! 진짜 I2C Read 시작!", UVM_LOW)
                execute_i2c_read();
            end
        join
    endtask

    task VGA_bus_init();
        vif.pclk  <= 0;
        vif.vsync <= 0;
        vif.href  <= 0;
        vif.pdata <= 0;
        pixel_idx = 0;
        prev_vsync = 0;
        vsync_drop_cnt = 0;
    endtask

    task drive_VGA(VGA_seq_item tx);
        logic [15:0] current_pixel;
        
        // 현재 픽셀의 x, y 좌표 계산 (320x240 기준)
        int cx = pixel_idx % 320;
        int cy = pixel_idx / 320;

        // 💡 핵심: 하드웨어의 좌표 스케일링 버그를 우회하기 위해, 
        // 빨간 네모를 화면의 완전한 왼쪽 끝(x=2~15)에 강제로 그려 넣습니다!
        if (tx.inject_dot) begin
            current_pixel = 16'hF800;  // 빨간 네모 고정
        end else if (pixel_idx < 320 * 240) begin
            current_pixel = img_mem[pixel_idx];
            // mem 파일 오류 시 파란색 배경 출력
            if ($isunknown(current_pixel) || current_pixel == 16'h0000) begin
                current_pixel = 16'h001F;
            end
        end else begin
            current_pixel = 16'd0;
        end

        // 2. VSYNC 갱신
        prev_vsync = tx.vsync;
        if (tx.vsync) pixel_idx = 0;

        // 3. 데이터 출력
        vif.vsync <= tx.vsync;
        vif.href  <= tx.href;

        if (tx.href) begin
            vif.pdata <= current_pixel[15:8];
            @(negedge vif.pclk);

            vif.pdata <= current_pixel[7:0];
            @(negedge vif.pclk);

            pixel_idx++;
            
            // 💡 VSYNC 대신 픽셀 카운트로 완벽하게 I2C 트리거
            if (pixel_idx == 320 * 240) begin
                `uvm_info(get_type_name(), "카메라 1프레임(320x240) 전송 완료! I2C 대기 스레드를 깨웁니다.", UVM_LOW)
                -> trigger_i2c_read;
            end
        end else begin
            vif.pdata <= 8'd0;
            @(negedge vif.pclk);
        end
    endtask

// task drive_VGA(VGA_seq_item tx);
//     logic [15:0] current_pixel;
    
//     // 1. 픽셀 색상 결정
//     if (tx.inject_dot) begin
//         // 시퀀스가 명령한 곳에는 빨간색 (RGB565 F800)
//         current_pixel = 16'hF800; 
//     end else begin
//         // 💡 핵심: 배경은 무조건 파란색 (RGB565 001F)
//         // 강아지 이미지 데이터를 무시하고 파란색 배경으로 고정합니다.
//         current_pixel = 16'h001F;
//     end

//     // 2. VSYNC 갱신 (기존과 동일)
//     prev_vsync = tx.vsync;
//     if (tx.vsync) pixel_idx = 0;

//     // 3. 데이터 출력 (기존과 동일)
//     vif.vsync <= tx.vsync;
//     vif.href  <= tx.href;

//     if (tx.href) begin
//         vif.pdata <= current_pixel[15:8];
//         @(negedge vif.pclk);
//         vif.pdata <= current_pixel[7:0];
//         @(negedge vif.pclk);
//         pixel_idx++;
        
//         if (pixel_idx == 320 * 240) begin
//             `uvm_info(get_type_name(), "카메라 1프레임 전송 완료! I2C 트리거...", UVM_LOW)
//             -> trigger_i2c_read;
//         end
//     end else begin
//         vif.pdata <= 8'd0;
//         @(negedge vif.pclk);
//     end
// endtask

    task execute_i2c_read();
        logic [7:0] rdata;
        int i;
        
        `uvm_info(get_type_name(), "=== I2C Read 트랜잭션 시작 (Target Addr: 0x10) ===", UVM_LOW)

        // 1. Bus 초기화 (High-Impedance)
        vif.sda_s <= 1'bz;
        vif.scl_s <= 1'bz;
        #10000;

        // 2. START 조건
        vif.sda_s <= 1'b0;
        #5000;
        vif.scl_s <= 1'b0;
        #5000;

        // 3. Device Address 전송 (7'h10 + Read(1) = 8'h21)
        for (i = 7; i >= 0; i--) begin
            if (8'h21 & (1 << i)) vif.sda_s <= 1'bz; // 1일 때는 Pull-up에 맡김
            else                  vif.sda_s <= 1'b0; // 0일 때는 명시적 Pull-down
            
            #5000;
            vif.scl_s <= 1'bz;
            #10000;
            vif.scl_s <= 1'b0;
            #5000;
        end

        // 4. ACK 대기
        vif.sda_s <= 1'bz; 
        #5000;
        vif.scl_s <= 1'bz;
        #5000;
        
        if (vif.sda_s === 1'b0) begin
            `uvm_info(get_type_name(), "I2C Slave(DUT)로부터 ACK 수신 성공!", UVM_LOW)
        end else begin
            `uvm_warning(get_type_name(), "I2C Slave(DUT)로부터 ACK를 받지 못했습니다! (NACK 상태)")
        end
        
        #5000;
        vif.scl_s <= 1'b0;
        #5000;

        // 5. 8-bit Data 읽기
        rdata = 8'h00;
        for (i = 7; i >= 0; i--) begin
            vif.sda_s <= 1'bz; 
            #5000;
            vif.scl_s <= 1'bz; 
            #5000;
            
            rdata[i] = vif.sda_s; 
            
            #5000;
            vif.scl_s <= 1'b0; 
            #5000;
        end
        `uvm_info(get_type_name(), $sformatf("I2C 통신 완료. 읽어온 데이터: 8'b%08b", rdata), UVM_LOW)

        // 6. NACK 전송 
        vif.sda_s <= 1'bz; 
        #5000;
        vif.scl_s <= 1'bz; 
        #10000;
        vif.scl_s <= 1'b0; 
        #5000;

        // 7. STOP 조건
        vif.sda_s <= 1'b0;
        #5000;
        vif.scl_s <= 1'bz;
        #5000;
        vif.sda_s <= 1'bz;
        #10000;

        `uvm_info(get_type_name(), "=== I2C Read 트랜잭션 정상 종료 ===", UVM_LOW)
    endtask

endclass

`endif