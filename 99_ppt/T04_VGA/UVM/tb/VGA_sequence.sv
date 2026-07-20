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
    // 1. 랜덤 변수 선언 (오직 X, Y 좌표와 점 생성 여부만!)
    // =========================================================
    rand int start_x;
    rand int start_y;
    rand bit enable_dot; // 0이면 점 없음(00), 1이면 랜덤 위치에 점 생성

    // 2. 제약 조건 (Constraints) - 화면 전체로 해제!
    // 💡 Y 좌표: 상단 무시 구역(0~160)부터 하단 끝까지 어디든 떨어질 수 있음 (상자 높이 20 고려)
    constraint c_y { start_y inside {[0:219]}; }

    // 💡 X 좌표: 화면 왼쪽 끝부터 오른쪽 끝까지 어디든 떨어질 수 있음 (상자 너비 15 고려)
    constraint c_x { start_x inside {[0:304]}; }

    // 점을 생성할 확률 설정 (예: 80% 확률로 점 생성, 20%는 빈 화면)
    constraint c_enable { enable_dot dist {1 := 80, 0 := 20}; }

    function new(string name = "VGA_single_area_noise_seq");
        super.new(name);
    endfunction

    virtual task body();
        VGA_seq_item item;
        
        // 3. 프레임 시작 전 랜덤화
        if (!this.randomize()) `uvm_error(get_type_name(), "랜덤화 실패!")

        if (enable_dot == 0)
            `uvm_info(get_type_name(), " 이번 프레임: 빈 화면 (빨간 점 없음, 00 출력 기대)", UVM_LOW)
        else
            `uvm_info(get_type_name(), $sformatf(" 이번 프레임: 무작위 폭격! 랜덤 좌표 (X: %0d~%0d, Y: %0d~%0d)에 점 생성!", 
                      start_x, start_x+15, start_y, start_y+20), UVM_LOW)

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

                // 4. 화면 밖으로 튀어나가지 않는 범위 내에서 랜덤 네모 주입
                if (enable_dot && y >= start_y && y <= start_y + 20 && x >= start_x && x <= start_x + 15) begin
                    item.inject_dot = 1'b1;
                    item.rand_dot_rgb = 16'hF800;
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