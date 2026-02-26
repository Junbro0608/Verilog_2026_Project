`timescale 1ns / 1ps
`define DATA_ADDR 16
`define BIT_WIDTH 8

interface sram_interface (
    input clk
);
    logic                          we;
    logic [$clog2(`DATA_ADDR)-1:0] addr;
    logic [        `BIT_WIDTH-1:0] wdata;
    logic [        `BIT_WIDTH-1:0] rdata;
endinterface  //sram_interface

class transaction;
    rand bit                          we;
    rand bit [$clog2(`DATA_ADDR)-1:0] addr;
    rand bit [        `BIT_WIDTH-1:0] wdata;
    logic    [        `BIT_WIDTH-1:0] rdata;

    function void display(string name);
        $display("%t: [%s] we = %d, addr = %2h, wdata = %2h, rdata = %2h",
                 $realtime, name, we, addr, wdata, rdata);
    endfunction
endclass  //transaction


class generator;
    transaction tr;

    mailbox #(transaction) gen2drv_mbox;
    event gen_next_ev;

    function new(mailbox#(transaction) gen2drv_mbox, event gen_next_ev);
        this.gen2drv_mbox = gen2drv_mbox;
        this.gen_next_ev  = gen_next_ev;
    endfunction  //new()

    task run(int run_cnt);
        repeat (run_cnt) begin
            tr = new();
            tr.randomize();
            gen2drv_mbox.put(tr);
            tr.display("gen");
            @(gen_next_ev);
        end
    endtask  //run
endclass  //generator

class driver;
    transaction tr;

    mailbox #(transaction) gen2drv_mbox;

    virtual sram_interface sram_if;

    function new(mailbox#(transaction) gen2drv_mbox,
                 virtual sram_interface sram_if);
        this.gen2drv_mbox = gen2drv_mbox;
        this.sram_if = sram_if;
    endfunction  //new()

    // task preset();
    //    sram_if.clk = 0;
    //    @(posedge sram_if.clk);
    // endtask

    task run();
        forever begin
            gen2drv_mbox.get(tr);
            @(negedge sram_if.clk);
            sram_if.we = tr.we;
            sram_if.addr = tr.addr;
            sram_if.wdata = tr.wdata;
            tr.display("drv");
        end
    endtask  //run
endclass  //driver

class monitor;
    transaction tr;

    mailbox #(transaction) mon2scb_mbox;

    virtual sram_interface sram_if;
    function new(mailbox#(transaction) mon2scb_mbox,
                 virtual sram_interface sram_if);
        this.mon2scb_mbox = mon2scb_mbox;
        this.sram_if = sram_if;
    endfunction  //new()

    task run();
        forever begin
            @(posedge sram_if.clk);
            #1;
            tr = new();
            tr.we = sram_if.we;
            tr.addr = sram_if.addr;
            tr.wdata = sram_if.wdata;
            tr.rdata = sram_if.rdata;

            mon2scb_mbox.put(tr);
            tr.display("mon");
        end
    endtask  //run
endclass  //monitor

class scoreboard;
    transaction tr;

    mailbox #(transaction) mon2scb_mbox;
    event gen_next_ev;

    int pass_cnt = 0, fail_cnt = 0, try_cnt = 0;

    covergroup cg_sram;
        cp_addr: coverpoint tr.addr{
            bins min = {0};
            bins max = {15};
            bins mid[] = {[1:14]};
        }
    endgroup

    function new(mailbox#(transaction) mon2scb_mbox, event gen_next_ev);
        this.mon2scb_mbox = mon2scb_mbox;
        this.gen_next_ev  = gen_next_ev;
        cg_sram = new();
    endfunction  //new()

    task run();
    logic [`BIT_WIDTH-1:0] scb_mem[0:`DATA_ADDR-1];
        forever begin
            mon2scb_mbox.get(tr);
            tr.display("scb");

            cg_sram.sample();

            if (tr.we) begin
                scb_mem[tr.addr] = tr.wdata;
                $display("%2h", scb_mem[tr.addr]);
            end else begin
                try_cnt++;
                if (scb_mem[tr.addr] === tr.rdata) begin
                    $display("[Pass]");
                    pass_cnt++;
                end else begin
                    $display(
                        "[Fail] we = %d, addr = %2h, wdata = %2h, rdata = %2h",
                        tr.we, tr.addr, tr.wdata, tr.rdata);
                    fail_cnt++;
                end
            end

            ->gen_next_ev;
        end

    endtask  //run
endclass  //scoreboard

class environment;
    transaction            tr;
    generator              gen;
    driver                 drv;
    monitor                mon;
    scoreboard             scb;


    mailbox #(transaction) gen2drv_mbox;
    mailbox #(transaction) mon2scb_mbox;

    event                  gen_next_ev;


    function new(virtual sram_interface sram_if);
        gen2drv_mbox = new();
        mon2scb_mbox = new();
        gen = new(gen2drv_mbox, gen_next_ev);
        drv = new(gen2drv_mbox, sram_if);
        mon = new(mon2scb_mbox, sram_if);
        scb = new(mon2scb_mbox, gen_next_ev);
    endfunction  //new()

    task run();
        fork
            gen.run(100);
            drv.run();
            mon.run();
            scb.run();
        join_any
        #10;

        $display("\n============================================");
        $display("           SRAM VERIFICATION REPORT          ");
        $display("============================================");
        $display("  STATUS    |  DESCRIPTION       |  COUNT    ");
        $display("------------+--------------------+----------");
        $display("  TOTAL     |  Total Trials      |   %3d    ", scb.try_cnt);
        $display("  PASS      |  Success Matches   |   %3d    ", scb.pass_cnt);
        $display("  FAIL      |  Mismatch Errors   |   %3d    ", scb.fail_cnt);
        $display("============================================");
        $display("coverage addr = %d%%",scb.cg_sram.get_inst_coverage());
        $display("============================================");
        $stop;
    endtask  //run

endclass  //environment


module tb_sram ();
    logic clk;
    sram_interface sram_if (clk);

    environment env;

    sram #(
        .DATA_ADDR(`DATA_ADDR),
        .BIT_WIDTH(`BIT_WIDTH)
    ) DUT (
        .clk  (clk),
        .we   (sram_if.we),
        .addr (sram_if.addr),
        .wdata(sram_if.wdata),
        .rdata(sram_if.rdata)
    );

    always #5 clk = ~clk;

    initial begin
        $timeformat(-9, 3, "ns");
        clk = 0;
        env = new(sram_if);
        env.run();
    end
endmodule
