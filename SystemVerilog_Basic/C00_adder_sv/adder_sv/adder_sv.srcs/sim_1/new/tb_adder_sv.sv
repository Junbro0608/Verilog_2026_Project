`timescale 1ns / 1ps

interface adder_interface;
    logic [31:0] a;
    logic [31:0] b;
    logic        mode;
    logic        c;
    logic [31:0] s;
endinterface  //adder_interface


class transation;
    rand bit [31:0] a;
    rand bit [31:0] b;
    bit             mode;
endclass  //transation

class generator;
    // varialbe declaration : data type transction
    transation tr;
    virtual adder_interface adder_interf_gen;
    function new(virtual adder_interface adder_interf_ext);
        adder_interf_gen = adder_interf_ext;
        tr               = new();
    endfunction

    task run();
        tr.randomize();

        adder_interf_gen.a    = tr.a;
        adder_interf_gen.b    = tr.b;
        adder_interf_gen.mode = tr.mode;

        //drive
        #10;
    endtask  //
endclass  //generator


module tb_adder_sv ();

    adder_interface adder_interf ();
    //class generator를 선언
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
        // generator class의 function newrk 실행됨
        //new 생성자
        gen = new(adder_interf);
        // 생성된 후 task run 실행
        gen.run();
        $stop;
    end

endmodule
