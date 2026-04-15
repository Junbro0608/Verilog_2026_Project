`include "uvm_macros.svh"
`include "tb_seq.svh"
import uvm_pkg::*;

interface ram_if (
    input logic clk
);
    //write
    logic        write;
    logic [ 7:0] addr;
    logic [15:0] wdata;
    //read
    logic [15:0] rdata;

    clocking drv_cb @(posedge clk);
        default input #1step output #0;
        output write;
        output addr;
        output wdata;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step;
        input write;
        input addr;
        input wdata;
        input rdata;
    endclocking
endinterface  //ram_if



class ram_driver extends uvm_driver #(ram_seq_item);
    `uvm_component_utils(ram_driver);

    virtual ram_if r_if;

    function new(string name = "DRV", uvm_component c);
        super.new(name, c);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ram_if)::get(this, "", "r_if", r_if)) begin
            `uvm_fatal(get_type_name(), "r_if를 찾을 수 없다 찾아라!");
        end
        `uvm_info(get_type_name(), "build_phase 실행 완료", UVM_HIGH);
    endfunction

    virtual task driver_item(ram_seq_item item);
        @(r_if.drv_cb);
        r_if.write <= item.write;
        r_if.addr  <= item.addr;
        r_if.wdata <= item.wdata;
        `uvm_info(get_type_name(), item.convert2string(), UVM_MEDIUM);
    endtask


    virtual task run_phase(uvm_phase phase);
        ram_seq_item item;

        forever begin
            seq_item_port.get_next_item(item);
            driver_item(item);
            seq_item_port.item_done();
        end
    endtask
endclass  //ram_driver extends uvm_driver

class ram_monitor extends uvm_monitor;
    `uvm_component_utils(ram_monitor)

    virtual ram_if                    r_if;
    uvm_analysis_port #(ram_seq_item) ap;



    function new(string name = "MON", uvm_component c);
        super.new(name, c);
        ap = new("ap", this);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ram_if)::get(this, "", "r_if", r_if)) begin
            `uvm_fatal(get_type_name(), "r_if를 찾을 수 없다 찾아라!");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            ram_seq_item item = ram_seq_item::type_id::create("item");
            `uvm_info(get_type_name(), "@(posedge) 대기 실행", UVM_DEBUG);
            @(r_if.mon_cb);
            item.write = r_if.write;
            item.addr  = r_if.addr;
            item.wdata = r_if.wdata;
            item.rdata = r_if.rdata;
            ap.write(item);
            `uvm_info(get_type_name(), item.convert2string(), UVM_MEDIUM);
        end
    endtask  //run_phase
endclass  //ram_monitor extends uvm_monitor

class ram_coverage extends uvm_subscriber #(ram_seq_item);
    `uvm_component_utils(ram_coverage);

    ram_seq_item item;

    covergroup ram_cg;
        cp_write: coverpoint item.write {bins write = {1}; bins read = {0};}
        cp_addr: coverpoint item.addr {
            bins min = {8'h0};
            bins max = {8'hff};
            bins range_low = {[8'h1 : 8'h7f]};
            bins range_high = {[8'h80 : 8'hfe]};
        }
        cp_wdata: coverpoint item.wdata {
            bins min = {16'h0};
            bins max = {16'hffff};
            bins range_low = {[16'h1 : 16'h7fff]};
            bins range_high = {[16'h8000 : 16'hfffe]};
        }
        cp_rdata: coverpoint item.rdata {
            bins min = {16'h0};
            bins max = {16'hffff};
            bins range_low = {[16'h1 : 16'h7fff]};
            bins range_high = {[16'h8000 : 16'hffff]};
        }
        //cross coverage
        cx_addr_wdata: cross cp_addr, cp_wdata;
        cx_addr_rdata: cross cp_addr, cp_rdata;
    endgroup

    function new(string name = "COV", uvm_component c);
        super.new(name, c);
        ram_cg = new();
    endfunction  //new()

    virtual function void write(ram_seq_item t);
        item = t;
        ram_cg.sample();
        `uvm_info(get_type_name(), $sformatf("counter_cg sampled: %s", item.convert2string()),
                  UVM_MEDIUM);
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf(
                  "\
        \n===== Coverage Summary =====\
        \n  write               : %.1f%%\
        \n  wdata               : %.1f%%\
        \n  rdata               : %.1f%%\
        \n  cross(addr, wdata)  : %.1f%%\
        \n  cross(addr, rdata)  : %.1f%%\
        \n============================",
                  ram_cg.cp_write.get_coverage(),
                  ram_cg.cp_wdata.get_coverage(),
                  ram_cg.cp_rdata.get_coverage(),
                  ram_cg.cx_addr_wdata.get_coverage(),
                  ram_cg.cx_addr_rdata.get_coverage()
                  ), UVM_LOW);
    endfunction
endclass  //ram_coverage extends uvm_subscriber#(counter_seq_item)

class ram_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(ram_scoreboard);

    uvm_analysis_imp #(ram_seq_item, ram_scoreboard) ap_imp;

    logic [7:0] raddr_past;
    logic read_done;
    logic [15:0] expected_mem[0:(2**8)-1];
    int error_cnt;
    int match_cnt;

    function new(string name = "SCR", uvm_component c);
        super.new(name, c);
        ap_imp = new("ap_imp", this);
        //init
        raddr_past = 0;
        read_done = 0;
        error_cnt = 0;
        match_cnt = 0;
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual function void write(ram_seq_item item);
        `uvm_info(get_type_name(), $sformatf("Recived: %s", item.convert2string()), UVM_MEDIUM);
        //save raddr_past & write wdata
        if (item.write == 0) begin
            raddr_past = item.addr;
            read_done  = 1;
        end else begin
            expected_mem[item.addr] = item.wdata;
        end

        //검증
        if (read_done) begin
            read_done = 0;
            if (expected_mem[item.addr] !== item.rdata) begin
                `uvm_error(get_type_name(), $sformatf(
                           "****불일치***** ADDR=%0d, 예상=%0d, 실제=%0d",
                           item.addr,
                           expected_mem[item.addr],
                           item.rdata
                           ));
                error_cnt++;
            end else begin
                `uvm_info(get_type_name(), $sformatf("일치! rdata=%0d", item.rdata), UVM_LOW);
                match_cnt++;
            end
        end
    endfunction

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), $sformatf("\
        \n===== Scoreboard Summary =====\
        \n  Total transaction   : %0d\
        \n  Matches             : %0d\
        \n  Error               : %0d\
        \n==============================", (match_cnt + error_cnt), match_cnt, error_cnt), UVM_LOW);

        if (error_cnt > 0) begin
            `uvm_error(get_type_name(), $sformatf("TEST FAILED: %0d mismatches detected!", error_cnt
                       ));
        end else begin
            `uvm_info(get_type_name(), $sformatf("TEST PASSED: %0d all matches detected!", match_cnt
                      ), UVM_LOW);
        end
    endfunction

endclass  //ram_scoreboard extends uvm_scoreboard

class ram_agent extends uvm_agent;
    `uvm_component_utils(ram_agent);

    uvm_sequencer #(ram_seq_item) sqr;
    ram_driver drv;
    ram_monitor mon;

    function new(string name = "AGT", uvm_component c);
        super.new(name, c);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = uvm_sequencer#(ram_seq_item)::type_id::create("sqr", this);
        drv = ram_driver::type_id::create("drv", this);
        mon = ram_monitor::type_id::create("mon", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass  //ram_agent extends uvm_agent

class ram_env extends uvm_env;
    `uvm_component_utils(ram_env);

    ram_agent      agt;
    ram_scoreboard scb;
    ram_coverage   cov;

    function new(string name = "ENV", uvm_component c);
        super.new(name, c);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = ram_agent::type_id::create("agt", this);
        scb = ram_scoreboard::type_id::create("scb", this);
        cov = ram_coverage::type_id::create("cov", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.mon.ap.connect(scb.ap_imp);
        agt.mon.ap.connect(cov.analysis_export);
    endfunction

endclass  //ram_env extends uvm_env

class ram_test extends uvm_test;
    `uvm_component_utils(ram_test);

    ram_env env;

    function new(string name, uvm_component c);
        super.new(name, c);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = ram_env::type_id::create("env", this);
        `uvm_info(get_type_name(), "env 생성", UVM_DEBUG);
    endfunction

    virtual task run_phase(uvm_phase phase);
        ram_master_seq seq;

        phase.raise_objection(this);
        seq = ram_master_seq::type_id::create("seq");
        seq.start(env.agt.sqr);
        #100;
        phase.drop_objection(this);
    endtask

    virtual function void report_phase(uvm_phase phase);
        uvm_report_server svr = uvm_report_server::get_server();
        if (svr.get_severity_count(UVM_ERROR) == 0) begin
            `uvm_info(get_type_name(), "===== TEST PASS ! =====", UVM_LOW);
        end else begin
            `uvm_info(get_type_name(), "===== TEST FAIL ! =====", UVM_LOW);
        end
    endfunction
endclass  //ram_test extends uvm_test


module moduleName ();
    logic clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    ram_if r_if (clk);


    ram DUT (
        .clk  (clk),
        //write
        .write(r_if.write),
        .addr (r_if.addr),
        .wdata(r_if.wdata),
        //read
        .rdata(r_if.rdata)
    );


    initial begin
        $timeformat(-9, 3, "ns");
        uvm_config_db#(virtual ram_if)::set(null, "*", "r_if", r_if);
        run_test("ram_test");
    end
endmodule
