`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "VGA_seq_item.sv"

class VGA_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(VGA_scoreboard)

    // 모니터에서 트랜잭션을 받을 포트
    uvm_analysis_imp #(VGA_seq_item, VGA_scoreboard) ap_imp;

    // 💡 원본(모니터) 해상도
    localparam SRC_WIDTH  = 320;
    localparam SRC_HEIGHT = 240;

    // 💡 DUT(하드웨어) 내부 판별 해상도
    localparam TARGET_WIDTH  = 106;
    localparam TARGET_HEIGHT = 120;

    // 통계용 변수
    int num_frames = 0;
    int num_passes = 0;
    int num_errors = 0;

    // 실패한 프레임 번호를 추적하기 위한 큐(Queue)
    int failed_frames[$];

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_imp = new("ap_imp", this);
    endfunction

    // ---------------------------------------------------------
    // 1. 모니터에서 데이터를 받아 채점하는 Write 함수
    // ---------------------------------------------------------
    virtual function void write(VGA_seq_item tx);
        logic [1:0] expected_data;
        logic [3:0] r, g, b, max_val, min_val;
        bit red_detect;
        int src_idx;
        int rom_x, rom_y;

        num_frames++;
        expected_data = 2'b00; 

        // 💡 106x120 기준으로 루프를 돌며 다운스케일링 적용
        for (int y = 0; y < TARGET_HEIGHT; y++) begin
            for (int x = 0; x < TARGET_WIDTH; x++) begin

                // 하드웨어(DownScaleimage)와 100% 동일한 원본 주소 계산
                rom_x = (x << 1) + x; // x * 3
                rom_y = (y << 1);     // y * 2

                // 모니터가 넘겨준 320x240 배열에서 1차원 인덱스 도출
                src_idx = (SRC_WIDTH * rom_y) + rom_x;

                // 픽셀 RGB 추출
                r = tx.VGA_image[src_idx][11:8];
                g = tx.VGA_image[src_idx][7:4];
                b = tx.VGA_image[src_idx][3:0];

                max_val = (r > g) ? ((r > b) ? r : b) : ((g > b) ? g : b);
                min_val = (r < g) ? ((r < b) ? r : b) : ((g < b) ? g : b);

                // 빨간색 검출
                red_detect = (r > g + 4'h2) && (r > b + 4'h2) && ((max_val - min_val) > 4'h2);

                // 영역 판별 (다운스케일된 기준 적용)
                if (red_detect) begin
                    if (y < 80) begin
                        expected_data = 2'b00;
                    end else begin
                        if (x > 1 && x < 36)       expected_data = 2'b01;
                        else if (x > 36 && x < 72) expected_data = 2'b10;
                        else if (x > 72)           expected_data = 2'b11;
                    end
                end
            end
        end

        // ---------------------------------------------------------
        // 2. 결과 비교 (Compare) 및 실패 추적
        // ---------------------------------------------------------
        if (expected_data !== tx.i2c_read_data[1:0]) begin
            num_errors++;
            failed_frames.push_back(num_frames);

            `uvm_error(
                get_type_name(),
                $sformatf(
                    "FAIL! [프레임 %0d] (디버깅 이미지: captured_frame_%0d.ppm) | 예상: 2'b%02b | DUT: 2'b%02b",
                    num_frames, num_frames, expected_data, tx.i2c_read_data[1:0]))
        end else begin
            num_passes++;
            `uvm_info(get_type_name(), $sformatf(
                      "PASS! [프레임 %0d] 예상: 2'b%02b | DUT 출력: 2'b%02b 일치함",
                      num_frames, expected_data, tx.i2c_read_data[1:0]
                      ), UVM_MEDIUM)
        end
    endfunction

    // ---------------------------------------------------------
    // 3. 시뮬레이션 종료 후 최종 리포트 출력
    // ---------------------------------------------------------
    virtual function void report_phase(uvm_phase phase);
        string result = (num_errors == 0) ? "** 검증 완벽 통과 (PASS) **" : "** 오류 발생 (FAIL) **";
        string fail_list_str = "";

        // 에러가 발생했다면, 실패한 프레임 번호들을 문자열로 묶기
        if (num_errors > 0) begin
            fail_list_str = "\n  [디버깅 필요 프레임]: ";
            foreach (failed_frames[i]) begin
                fail_list_str = {fail_list_str, $sformatf("%0d ", failed_frames[i])};
            end
        end

        super.report_phase(phase);
        `uvm_info(get_type_name(), $sformatf(
                  "\
        \n=======================================\
        \n      VGA Red Detect Summary Report   \
        \n=======================================\
        \n  Result      : %s\
        \n  총 프레임 수: %0d\
        \n  PASS 횟수   : %0d\
        \n  FAIL 횟수   : %0d%s\
        \n=======================================",
                  result,
                  num_frames,
                  num_passes,
                  num_errors,
                  fail_list_str
                  ), UVM_NONE)
    endfunction

endclass

`endif