`timescale 1ns / 1ps

interface ram_if (
    input clk
);
    logic       we;
    logic [7:0] addr;
    logic [7:0] wdata;
    logic [7:0] rdata;
endinterface  //ram_if

class test;
    virtual ram_if ram_if;

    function new(virtual ram_if ram_if);
        this.ram_if = ram_if;
    endfunction  //new()

    virtual task write(logic [7:0] waddr, logic [7:0] data);
        ram_if.we    = 1;
        ram_if.addr  = waddr;
        ram_if.wdata = data;
        @(posedge ram_if.clk);
    endtask  //ram_write

    virtual task read(logic [7:0] raddr);
        ram_if.we   = 0;
        ram_if.addr = raddr;
        @(posedge ram_if.clk);
    endtask  //ram_read
endclass  //test

class test_busrt extends test;
    function new(virtual ram_if ram_if);
        super.new(ram_if);

    endfunction  //new()

    task write_burst(logic [7:0] waddr, logic [7:0] data, int len);
        for (int i = 0; i < len; i++) begin
            write(waddr, data);
            waddr++;
        end

    endtask  //write_burst

    task write(logic [7:0] waddr, logic [7:0] data);
        ram_if.we    = 1;
        ram_if.addr  = waddr+1;
        ram_if.wdata = data;
        @(posedge ram_if.clk);
    endtask  //write
endclass  //test_busrt extends test

class transaction;
    logic            we;
    rand logic [7:0] addr;
    rand logic [7:0] wdata;
    logic      [7:0] rdata;

    constraint c_addr {
        addr inside {[8'h00:8'h10]};
    }
    constraint c_wdata {
        wdata inside {[8'h10:8'h20]};
    }

    function new(string name);
        $display("[%s] we:%0d, addr:0x%0x, wdata:0x%0x, rdata:0x%0x", name, we,
                 addr, wdata, rdata);
    endfunction  //new()
endclass  //transaction

class test_rand extends test;
    transaction tr;

    function new(virtual ram_if ram_if);
        super.new(ram_if);
    endfunction  //new()

    task write_rand(int loop);
        repeat (loop) begin
            tr = new("test_rand");
            tr.randomize();
            ram_if.we    = 1;
            ram_if.addr  = tr.addr;
            ram_if.wdata = tr.wdata;
            @(posedge ram_if.clk);
        end
    endtask  //write_rand()

endclass  //test_rand extends test



module tb_ram ();
    logic clk;
    test BTS;
    test_rand BlackPink;

    ram_if ram_if (clk);

    ram U_RAM (
        .clk  (ram_if.clk),
        .we   (ram_if.we),
        .addr (ram_if.addr),
        .wdata(ram_if.wdata),
        .rdata(ram_if.rdata)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        repeat (5) @(posedge clk);
        BTS = new(ram_if);
        BlackPink = new(ram_if);
        $display("%h", BTS);
        $display("%h", BlackPink);

        BTS.write(8'h00, 8'h01);
        BTS.write(8'h01, 8'h02);
        BTS.write(8'h02, 8'h03);
        BTS.write(8'h03, 8'h04);

        BlackPink.write_rand(10);
        // BlackPink.write(8'h01, 8'h02);
        // BlackPink.write(8'h02, 8'h03);
        // BlackPink.write(8'h03, 8'h04);

        BTS.read(8'h00);
        BTS.read(8'h01);
        BTS.read(8'h02);
        BTS.read(8'h03);

        #20;
        $finish;

    end
endmodule
