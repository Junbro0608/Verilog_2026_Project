`ifndef TEST_SV
`define TEST_SV

`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

// (주의: VGA_env 클래스가 Include 되어 있어야 합니다)

// ---------------------------------------------------------
// 1. Base Test (공통 환경 및 토폴로지 설정)
// ---------------------------------------------------------
class VGA_base_test extends uvm_test;
    `uvm_component_utils(VGA_base_test)

    VGA_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = VGA_env::type_id::create("env", this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info(get_type_name(), "===== UVM 계층 구조 (Topology) =====", UVM_LOW)
        uvm_top.print_topology();
    endfunction
endclass

// ---------------------------------------------------------
// 2. 단일 영역(Area 1) 노이즈 주입 테스트
// ---------------------------------------------------------
class VGA_single_area_test extends VGA_base_test;
    `uvm_component_utils(VGA_single_area_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        VGA_single_area_noise_seq seq;
        
        phase.raise_objection(this);
        `uvm_info(get_type_name(), "=== 100번 랜덤 스트레스 테스트 시작! ===", UVM_LOW)

        // 💡 100번 반복하면서 시퀀스의 랜덤화를 매번 호출합니다.
        repeat (500) begin
            seq = VGA_single_area_noise_seq::type_id::create("seq");
            
            // seq.target_area = area; <-- 이 줄은 지워주세요! (시퀀스가 스스로 랜덤 결정함)
            
            seq.start(env.agt.sqr);

            #40000000; // 1프레임 통신 대기
        end

        `uvm_info(get_type_name(), "=== 100번 랜덤 스트레스 테스트 완벽 종료! ===", UVM_LOW)
        phase.drop_objection(this);
    endtask
endclass

// ---------------------------------------------------------
// 3. QVGA 전체 영역(Area 1~3) 노이즈 주입 테스트
// ---------------------------------------------------------
class VGA_full_area_test extends VGA_base_test;
    `uvm_component_utils(VGA_full_area_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        VGA_single_area_noise_seq seq;

        phase.raise_objection(this);

        seq = VGA_single_area_noise_seq::type_id::create("seq");
        `uvm_info(get_type_name(),
                  "[TEST] QVGA 3개 영역 랜덤 노이즈 주입 시나리오 시작", UVM_LOW)

        // Sequencer를 통해 시퀀스 실행
        seq.start(env.agt.sqr);

        #30ms;
        phase.drop_objection(this);
    endtask
endclass

`endif
