`timescale 1ns / 1ps

`define BIT_WIDTH 8

interface register_interface;
    logic                  clk;
    logic                  rst;
    logic                  we;
    logic [`BIT_WIDTH-1:0] wdata;
    logic [`BIT_WIDTH-1:0] rdata;

    property Preset_check;
        @(posedge clk) rst |=> (rdata == 1'b0);
    endproperty
    reg_reset_check :
    assert property (Preset_check)
    else $display("%t: Assert error : reset check", $realtime);
endinterface  //register_if

class transaction;

    rand bit                  we;
    rand bit [`BIT_WIDTH-1:0] wdata;
    bit      [`BIT_WIDTH-1:0] rdata;

    task display(string name);
        $display("%t : [%s] we = %h, wdata = %h, rdata = %h", $time, name, we,
                 wdata, rdata);

    endtask


endclass  //transaction

class generator;
    transaction tr;
    mailbox #(transaction) gen2drv_mbox;
    event gen_next_ev;

    function new(mailbox#(transaction) gen2drv_mbox, event gen_next_ev);
        this.gen2drv_mbox = gen2drv_mbox;
        this.gen_next_ev  = gen_next_ev;
    endfunction  //new()

    task run(int run_count);
        repeat (run_count) begin
            tr = new();

            assert (tr.randomize())
            else $display("[gen] ERROR tr.randomize()");

            gen2drv_mbox.put(tr);
            tr.display("gen");
            @(gen_next_ev);
        end
    endtask
endclass  //generator

class driver;
    transaction tr;
    mailbox #(transaction) gen2drv_mbox;
    virtual register_interface register_if;

    function new(mailbox#(transaction) gen2drv_mbox,
                 virtual register_interface register_if);
        this.gen2drv_mbox = gen2drv_mbox;
        this.register_if  = register_if;
    endfunction  //new()

    task preset();
        register_if.clk = 0;
        register_if.rst = 1;
        register_if.we = 0;
        register_if.wdata = 0;
        @(posedge register_if.clk);
        @(posedge register_if.clk);
        register_if.rst = 0;
        @(posedge register_if.clk);
    endtask

    task run();
        forever begin
            gen2drv_mbox.get(tr);
            @(negedge register_if.clk);
            register_if.we    = tr.we;
            register_if.wdata = tr.wdata;
            tr.display("drv");
        end
    endtask  //run
endclass  //driver

class monitor;
    transaction tr;
    mailbox #(transaction) mon2scb_mbox;
    virtual register_interface register_if;


    function new(mailbox#(transaction) mon2scb_mbox,
                 virtual register_interface register_if);
        this.mon2scb_mbox = mon2scb_mbox;
        this.register_if  = register_if;
    endfunction  //new()

    task run();
        forever begin
            tr = new();
            @(posedge register_if.clk);
            #1;
            tr.we    = register_if.we;
            tr.wdata = register_if.wdata;
            tr.rdata = register_if.rdata;
            mon2scb_mbox.put(tr);
            tr.display("mon");
        end
    endtask

endclass  //monitor

class scoreboard;
    transaction tr;
    mailbox #(transaction) mon2scb_mbox;

    event gen_next_ev;

    int pass_cnt = 0, fail_cnt = 0, try_cnt = 0;

    function new(mailbox#(transaction) mon2scb_mbox, event gen_next_ev);
        this.mon2scb_mbox = mon2scb_mbox;
        this.gen_next_ev  = gen_next_ev;
    endfunction  //new()

    task run();
        forever begin
            mon2scb_mbox.get(tr);
            try_cnt++;
            if (tr.we) begin
                if (tr.wdata == tr.rdata) begin
                    $display("%t: Pass=>we = %h, wdata = %h, rdata = %h",
                             $realtime, tr.we, tr.wdata, tr.rdata);
                    pass_cnt++;
                end else begin
                    $display("%t: Fail=>we = %h, wdata = %h, rdata = %h",
                             $realtime, tr.we, tr.wdata, tr.rdata);
                    fail_cnt++;
                end
            end

            tr.display("scr");
            ->gen_next_ev;
        end
    endtask

endclass  //scoreboard


class environment;

    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;

    mailbox #(transaction) gen2drv_mbox;
    mailbox #(transaction) mon2scb_mbox;

    event gen_next_ev;

    function new(virtual register_interface register_if);
        gen2drv_mbox = new();
        mon2scb_mbox = new();
        gen = new(gen2drv_mbox, gen_next_ev);
        drv = new(gen2drv_mbox, register_if);
        mon = new(mon2scb_mbox, register_if);
        scb = new(mon2scb_mbox, gen_next_ev);
    endfunction  //new()

    task run();
        drv.preset();
        fork
            gen.run(10);
            drv.run();
            mon.run();
            scb.run();
        join_any
        #20;

        $display("\n============================================");
        $display("      8-BIT REGISTER VERIFICATION REPORT      ");
        $display("============================================");
        $display("  STATUS    |  DESCRIPTION       |  COUNT    ");
        $display("------------+--------------------+----------");
        $display("  TOTAL     |  Total Trials      |   %3d    ", scb.try_cnt);
        $display("  PASS      |  Success Matches   |   %3d    ", scb.pass_cnt);
        $display("  FAIL      |  Mismatch Errors   |   %3d    ", scb.fail_cnt);
        $display("============================================");


        $stop;
    endtask
endclass  //environment


module tb_register ();

    register_interface register_if ();
    environment env;


    register #(
        .BIT_WIDTH(`BIT_WIDTH)
    ) DUT (
        .clk  (register_if.clk),
        .rst  (register_if.rst),
        .we   (register_if.we),
        .wdata(register_if.wdata),
        .rdata(register_if.rdata)
    );

    always #5 register_if.clk = ~register_if.clk;

    initial begin
        $timeformat(-9, 3, "ns");
        register_if.clk = 0;
        register_if.rst = 1;
        env             = new(register_if);
        env.run();
    end
endmodule
