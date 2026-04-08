`include "uvm_macros.svh"
import uvm_pkg::*;

class ram_seq_item extends uvm_sequence_item;
    //write
    rand bit        write;
    rand bit [ 7:0] addr;
    rand bit [15:0] wdata;
    //read
    logic    [15:0] rdata;

    `uvm_object_utils_begin(ram_seq_item)
        `uvm_field_int(write, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(wdata, UVM_ALL_ON)
        `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "ram_seq_item");
        super.new(name);
    endfunction

    function string convert2string();
        return $sformatf(
            "write=%0b, addr=%0d, wdata=%0d, rdata=%0d",
            write,
            addr,
            wdata,
            rdata
        );
    endfunction
endclass

class ram_reset_seq extends uvm_sequence #(ram_seq_item);
    `uvm_object_utils(ram_reset_seq);
    int num_transations;

    function new(string name = "ram_reset_seq");
        super.new(name);
    endfunction  //new()

    virtual task body();
        ram_seq_item item;
        //write to 0~255 addr
        for (int i = 0; i < num_transations; i++) begin
            item = ram_seq_item::type_id::create($sformatf("item_%0d", i));

            start_item(item);
            item.write       = 1;
            item.addr        = i;
            item.wdata       = 16'b0;
            finish_item(item);

        end
        `uvm_info(get_type_name(), "Reset Done!", UVM_MEDIUM);
    endtask
endclass


//0~256번지까지 오직 쓰고 0~256번지까지 읽기
class ram_only_read_seq extends uvm_sequence #(ram_seq_item);
    `uvm_object_utils(ram_only_read_seq);

    int num_transations;

    function new(string name = "ram_only_read_seq");
        super.new(name);
    endfunction  //new()

    virtual task body();
        ram_seq_item item;
        //write to 0~255 addr
        for (int i = 0; i < num_transations; i++) begin
            item = ram_seq_item::type_id::create($sformatf("item_%0d", i));

            start_item(item);
            if (!item.randomize()) begin
                `uvm_fatal(get_type_name(), "randomization failed");
            end
            item.write  = 1;
            item.addr   = i;
            finish_item(item);

            `uvm_info(get_type_name(), $sformatf(
                      "[%0d/%0d] %s", i + 1, num_transations, item.convert2string()), UVM_HIGH);
        end
        //read to 0~255 addr
        for (int i = 0; i < num_transations; i++) begin
            item = ram_seq_item::type_id::create($sformatf("item_%0d", i));

            start_item(item);
            item.write  = 0;
            item.addr   = i;
            finish_item(item);
            `uvm_info(get_type_name(), $sformatf(
                      "[%0d/%0d] %s", i + 1, num_transations, item.convert2string()), UVM_HIGH);
        end
    endtask  //
endclass  //ram_only_read_seq extends uvm_sequence #(ram_seq_item)

//랜덤 쓰고 읽기
class ram_random_read_write_seq extends uvm_sequence #(ram_seq_item);
    `uvm_object_utils(ram_random_read_write_seq);

    int num_transations;

    function new(string name = "ram_random_read_write_seq");
        super.new(name);
    endfunction  //new()

    virtual task body();
        ram_seq_item item;
        //rand read write
        for (int i = 0; i < num_transations; i++) begin
            item = ram_seq_item::type_id::create($sformatf("item_%0d", i));

            start_item(item);
            if (!item.randomize()) begin
                `uvm_fatal(get_type_name(), "randomization failed");
            end
            finish_item(item);

            `uvm_info(get_type_name(), $sformatf(
                      "[%0d/%0d] %s", i + 1, num_transations, item.convert2string()), UVM_HIGH);
        end
    endtask  //
endclass  //ram_random_read_write_seq extends uvm_sequence #(ram_seq_item)



class ram_master_seq extends uvm_sequence #(ram_seq_item);
    `uvm_object_utils(ram_master_seq);

    function new(string name = "ram_master_seq");
        super.new(name);
    endfunction  //new()

    virtual task body();
        ram_reset_seq             reset_seq;
        ram_only_read_seq         only_read_seq;
        ram_random_read_write_seq random_read_seq;

        //0~256번지까지 오직 쓰고 0~256번지까지 읽기
        `uvm_info(get_type_name(), "===== Phase1 : Only Read =====", UVM_MEDIUM);
        only_read_seq = ram_only_read_seq::type_id::create("only_read_seq");
        only_read_seq.num_transations = (2 ** 8);
        only_read_seq.start(m_sequencer);
        #20;
        // `uvm_info(get_type_name(), "===== Phase2 : Reset =====", UVM_MEDIUM);
        // reset_seq = ram_reset_seq::type_id::create("reset_seq");
        // reset_seq.num_transations = (2 ** 8);
        // reset_seq.start(m_sequencer);
        // #20;
        //랜덤 쓰고 읽기
        `uvm_info(get_type_name(), "===== Phase2 : random Read =====", UVM_MEDIUM);
        random_read_seq = ram_random_read_write_seq::type_id::create("only_read_seq");
        random_read_seq.num_transations = 50;
        random_read_seq.start(m_sequencer);
        #20;
        `uvm_info(get_type_name(), "===== Master Sequence done =====", UVM_MEDIUM);
    endtask
endclass  //ram_master_seq extends uvm_sequence #(ram_seq_item)
