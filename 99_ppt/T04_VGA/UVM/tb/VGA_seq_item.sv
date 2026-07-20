`ifndef SEQ_ITEM_SV
`define SEQ_ITEM_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class VGA_seq_item extends uvm_sequence_item;
    //OV7670
    logic             pclk;
    logic             xclk;
    logic             href;
    logic             vsync;
    logic      [ 7:0] pdata;
    
    //VGA
    logic      [ 3:0] port_red;
    logic      [ 3:0] port_green;
    logic      [ 3:0] port_blue;
    logic             h_sync;
    logic             v_sync;
    
    // 랜덤 점 주입
    rand logic [15:0] rand_dot_rgb;
    rand bit          inject_dot;

    // 모니터 -> 스코어보드 전달용 데이터
    logic [7:0]  i2c_read_data;                   // I2C 캡처 데이터
    logic [11:0] VGA_image [0:(320*240)-1];       // QVGA 1프레임 이미지 (R:4, G:4, B:4)

    // =========================================================
    // 💡 1. 랜덤 제약(Constraint) 추가
    // =========================================================
    constraint c_noise_prob {
        // 노이즈(점)가 찍힐 확률을 2%, 정상 픽셀 확률을 98%로 설정
        // (필요에 따라 시퀀스에서 이 제약을 덮어쓸 수도 있습니다)
        inject_dot dist { 1 := 2, 0 := 98 };
    }

    `uvm_object_utils_begin(VGA_seq_item)
        `uvm_field_int(inject_dot, UVM_ALL_ON)
        `uvm_field_int(rand_dot_rgb, UVM_ALL_ON)
        `uvm_field_int(pclk, UVM_ALL_ON)
        `uvm_field_int(xclk, UVM_ALL_ON)
        `uvm_field_int(href, UVM_ALL_ON)
        `uvm_field_int(vsync, UVM_ALL_ON)
        `uvm_field_int(pdata, UVM_ALL_ON)
        `uvm_field_int(port_red, UVM_ALL_ON)
        `uvm_field_int(port_green, UVM_ALL_ON)
        `uvm_field_int(port_blue, UVM_ALL_ON)
        `uvm_field_int(h_sync, UVM_ALL_ON)
        `uvm_field_int(v_sync, UVM_ALL_ON)
        `uvm_field_int(i2c_read_data, UVM_ALL_ON)
        // 🚨 VGA_image 배열은 매크로 제외 유지
    `uvm_object_utils_end

    function new(string name = "VGA_seq_item");
        super.new(name);
    endfunction  //new()

    // =========================================================
    // 💡 2. 수동 복사 로직 추가 (do_copy 오버라이딩)
    // =========================================================
    virtual function void do_copy(uvm_object rhs);
        VGA_seq_item rhs_;
        
        // 1. 부모 클래스의 기본 복사 실행 (매크로에 등록된 변수들 복사)
        super.do_copy(rhs);
        
        // 2. 타입 캐스팅
        if (!$cast(rhs_, rhs)) begin
            `uvm_fatal("do_copy", "Type cast failed!")
        end
        
        // 3. 매크로에서 제외했던 거대 배열을 SystemVerilog 문법으로 통째로 복사
        this.VGA_image = rhs_.VGA_image;
    endfunction

    function string convert2string();
        return $sformatf(
            "VGA_ITEM | inject_dot: %b | rand_dot: 0x%04h | OV7670 pdata: 0x%02h | VGA Out: R(%x) G(%x) B(%x) | I2C Read: 0x%02h",
            inject_dot, 
            rand_dot_rgb, 
            pdata, 
            port_red, 
            port_green, 
            port_blue,
            i2c_read_data
        );
    endfunction

endclass  //component extends uvm_componet

`endif