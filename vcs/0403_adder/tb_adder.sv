`include "uvm_macros.svh"
import uvm_pkg::*;

class hello_test extends uvm_test;
    `uvm_component_utils(hello_test)


    function new(string name = "hello_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("HELLO", "첫 번째 UVM 프로그램이 실행되었습니다", UVM_LOW);
        `uvm_info("HELLO", "UVM 환경 설정 성공! 다음 준비 완료", UVM_LOW);
        `uvm_error("ERROR", "UVM 환경 설정 에러! 다음 준비 미완료");
        #100;
        phase.drop_objection(this);
    endtask //run_phase
endclass //hello_test extends uvm_test

module test_uvm ();
    initial begin
        run_test("hello_test");
    end
endmodule