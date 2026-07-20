`ifndef SEQUENCE_SV
`define SEQUENCE_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "VGA_seq_item.sv"

class VGA_base_seq extends uvm_sequence #(VGA_seq_item);
    `uvm_object_utils(VGA_base_seq)
    
    localparam WIDTH  = 320;
    localparam HEIGHT = 240;

    function new(string name = "VGA_base_seq");
        super.new(name);
    endfunction

    virtual task body();
    endtask
endclass

class VGA_single_area_noise_seq extends VGA_base_seq;
    `uvm_object_utils(VGA_single_area_noise_seq)

    // =========================================================
    // 1. 랜덤 변수 선언 (구역 번호, 점의 시작 X, Y 좌표)
    // =========================================================
    rand int target_area;
    rand int start_x;
    rand int start_y;

    // 2. 제약 조건 (Constraints)
    constraint c_area { target_area inside {0, 1, 2, 3}; }

    // 💡 Y 좌표: 원본 캔버스 기준 커트라인인 160(80*2) 아래쪽으로 배치 (상자 높이 20 고려)
    constraint c_y { start_y inside {[170:210]}; }

    // 💡 X 좌표: 원본 캔버스 기준 경계선(108, 216)에 맞게 안전지대 재설정 (상자 너비 15 고려)
    constraint c_x {
        if (target_area == 0) start_x == 0;
        
        // Area 1 (원본 기준 x < 108) -> 20부터 80까지 (최대 80+15=95)
        if (target_area == 1) start_x inside {[20:80]};   
        
        // Area 2 (원본 기준 108 < x < 216) -> 130부터 190까지 (최대 190+15=205)
        if (target_area == 2) start_x inside {[130:190]};  
        
        // Area 3 (원본 기준 x > 216) -> 230부터 290까지 (최대 290+15=305)
        if (target_area == 3) start_x inside {[230:290]}; 
    }

    function new(string name = "VGA_single_area_noise_seq");
        super.new(name);
    endfunction

    virtual task body();
        VGA_seq_item item;
        
        // 3. 프레임 시작 전, 변수들을 랜덤하게 섞습니다!
        if (!this.randomize()) `uvm_error(get_type_name(), "랜덤화 실패!")

        if (target_area == 0)
            `uvm_info(get_type_name(), " 이번 프레임 타겟: 점 없음 (00 출력 기대)!", UVM_LOW)
        else
            `uvm_info(get_type_name(), $sformatf(" 이번 프레임 타겟: Area %0d 랜덤 좌표 (X: %0d~%0d, Y: %0d~%0d) 생성!", 
                      target_area, start_x, start_x+15, start_y, start_y+20), UVM_LOW)

        // 프레임 시작 VSYNC
        for (int i = 0; i < 3; i++) begin
            item = VGA_seq_item::type_id::create("item");
            start_item(item); item.inject_dot = 1'b0; item.vsync = 1'b1; item.href = 1'b0; finish_item(item);
        end

        // 실제 영상 데이터 전송
        for (int y = 0; y < HEIGHT; y++) begin
            for (int x = 0; x < WIDTH; x++) begin
                item = VGA_seq_item::type_id::create("item");
                start_item(item);

                // 4. 랜덤으로 결정된 start_x, start_y를 기준으로 15x20 크기의 네모 주입
                if (target_area != 0 && y >= start_y && y <= start_y + 20 && x >= start_x && x <= start_x + 15) begin
                    item.inject_dot = 1'b1;
                    item.rand_dot_rgb = 16'hF800; // 랜덤 좌표에 빨간 점!
                end else begin
                    item.inject_dot = 1'b0;
                    item.rand_dot_rgb = 16'h0000;
                end

                item.href = 1'b1; item.vsync = 1'b0;
                finish_item(item);
            end
            
            for (int b = 0; b < 10; b++) begin
                item = VGA_seq_item::type_id::create("item");
                start_item(item); item.inject_dot = 1'b0; item.href = 1'b0; item.vsync = 1'b0; finish_item(item);
            end
        end

        // 프레임 종료 VSYNC
        for (int i = 0; i < 5; i++) begin
            item = VGA_seq_item::type_id::create("item");
            start_item(item); item.inject_dot = 1'b0; item.vsync = 1'b1; item.href = 1'b0; finish_item(item);
        end
        for (int i = 0; i < 5; i++) begin
            item = VGA_seq_item::type_id::create("item");
            start_item(item); item.inject_dot = 1'b0; item.vsync = 1'b0; item.href = 1'b0; finish_item(item);
        end
    endtask
endclass

`endif