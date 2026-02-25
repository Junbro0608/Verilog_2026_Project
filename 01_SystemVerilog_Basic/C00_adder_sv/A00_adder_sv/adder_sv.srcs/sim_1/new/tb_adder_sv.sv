`timescale 1ns / 1ps

interface adder_interface;
    logic [31:0] a;
    logic [31:0] b;
    logic        mode;
    logic        c;
    logic [31:0] s;
endinterface  //adder_interface


class transaction;
    rand bit [31:0] a;
    rand bit [31:0] b;
    bit             mode;
endclass  //transaction

class generator;
    // varialbe declaration : data type transction
    transaction tr;
    virtual adder_interface adder_interf_gen;

    // 검증을 위한 내부 변수
    logic [32:0] expected_full;  // 32비트 + Carry 1비트 포함

    function new(virtual adder_interface adder_interf_ext);
        this.adder_interf_gen = adder_interf_ext;
        tr                    = new();
    endfunction

    task run();
        repeat (10) begin
            tr.randomize();

            adder_interf_gen.a    = tr.a;
            adder_interf_gen.b    = tr.b;
            adder_interf_gen.mode = tr.mode;

            expected_full = tr.a + tr.b;

            //drive
            #10;
            //검증
            if ({adder_interf_gen.c, adder_interf_gen.s} == expected_full) begin
                $display("%t ps => [INFO] %h + %h = %h [T]", $time,
                         adder_interf_gen.a, adder_interf_gen.b,
                         adder_interf_gen.s);
            end else begin
                $display("%t ps => [INFO] %h + %h = %h [F]", $time,
                         adder_interf_gen.a, adder_interf_gen.b,
                         adder_interf_gen.s);
            end
        end
    endtask  //
endclass  //generator


module tb_adder_sv ();

    //hw 실체화
    adder_interface adder_interf ();
    //class generator를 선언
    //gen : generator 객체를 관리하기 위한 handler()
    generator gen;

    adder #(
        .BIT_WIDTH(32)
    ) DUT (
        .mode(adder_interf.mode),
        .a   (adder_interf.a),
        .b   (adder_interf.b),
        .s   (adder_interf.s),
        .c   (adder_interf.c)
    );

    initial begin
        //class generator 를 생성
        //generator class의 function newrk 실행됨
        //new 생성자
        gen = new(adder_interf);
        // 생성된 후 task run 실행
        gen.run();

        $stop;
    end

endmodule
