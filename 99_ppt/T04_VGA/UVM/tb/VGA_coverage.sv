`ifndef COVERAGE_SV
`define COVERAGE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "VGA_seq_item.sv"

class VGA_coverage extends uvm_subscriber #(VGA_seq_item);
    `uvm_component_utils(VGA_coverage)

    VGA_seq_item tx;

    // =========================================================
    // 💡 Coverage Group: 우리가 확인해야 할 핵심 시나리오
    // =========================================================
    covergroup VGA_cg;
        
        // 1. 노이즈 주입 커버리지: 시퀀스가 점을 찍은 프레임과 안 찍은 프레임이 모두 있었는가?
        cp_inject_dot: coverpoint tx.inject_dot {
            bins injected     = {1};
            bins not_injected = {0};
        }

        // 2. I2C 감지 결과 커버리지: DUT가 4가지 영역 판별을 모두 뱉어보았는가?
        cp_i2c_result: coverpoint tx.i2c_read_data[1:0] {
            bins no_red = {2'b00}; // 빨간색 없음 (또는 상단 영역)
            bins area_1 = {2'b01}; // X: 1 ~ 36 구역 감지
            bins area_2 = {2'b10}; // X: 36 ~ 72 구역 감지
            bins area_3 = {2'b11}; // X: 72 이상 구역 감지
        }

        // 3. 교차(Cross) 커버리지: 특정 노이즈 상황에서 특정 결과를 보았는가?
        cx_inject_result: cross cp_inject_dot, cp_i2c_result;
        
    endgroup

    function new(string name = "VGA_coverage", uvm_component c);
        super.new(name, c);
        VGA_cg = new();
    endfunction

    // 모니터로부터 트랜잭션이 날아올 때마다 실행 (1프레임당 1번 샘플링)
    virtual function void write(VGA_seq_item t);
        tx = t;
        VGA_cg.sample();
        // `uvm_info(get_type_name(), $sformatf("Coverage Sampled: Inject=%b, I2C_Res=2'b%02b", tx.inject_dot, tx.i2c_read_data[1:0]), UVM_DEBUG)
    endfunction

    // 시뮬레이션 종료 시 커버리지 달성률 출력
    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("\
        \n===========================================\
        \n       VGA Red Detect Coverage Summary     \
        \n===========================================\
        \n  노이즈 주입(inject_dot) 커버리지  : %0.1f%%\
        \n  I2C 감지 결과(i2c_result) 커버리지: %0.1f%%\
        \n  Cross 커버리지                    : %0.1f%%\
        \n  Total 커버리지                    : %0.1f%%\
        \n===========================================",
        VGA_cg.cp_inject_dot.get_coverage(),
        VGA_cg.cp_i2c_result.get_coverage(),
        VGA_cg.cx_inject_result.get_coverage(),
        VGA_cg.get_coverage()
        ), UVM_LOW);
    endfunction
endclass

`endif