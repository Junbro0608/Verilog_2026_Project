class weapon;
    string name;

    function new(string name);
        this.name = name;
    endfunction  //new()

    virtual function void shot();
        $display(" [%s] ... (소리 없음)", name);
    endfunction
endclass  //weapon

class M16 extends weapon;
    bit [15:0] checksum;

    function new(string name);
        super.new(name);
    endfunction  //new()

    virtual function void shot();
        $display(" [%s] 탕탕!", name);
    endfunction
endclass  //M16 extends weapon

class AUG extends weapon;
    bit [15:0] checksum;

    function new(string name);
        super.new(name);
    endfunction  //new()

    virtual function void shot();
        $display(" [%s] 삐~~~익~~~텅텅!", name);
    endfunction
endclass  //AUG extends weapon

class K2 extends weapon;
    bit [15:0] checksum;

    function new(string name);
        super.new(name);
    endfunction  //new()

    virtual function void shot();
        $display(" [%s] 타당타당!", name);
    endfunction
endclass  //K2 extends weapon


module tb_oop ();
    initial begin
        weapon BlackPink = new("없음");
        weapon gun = new("주먹");
        M16    m16 = new("M16");
        AUG    aug = new("AUG");
        K2     k2 = new("k2");


        $display("===== 다향성 데모 =====");
        BlackPink.shot();
        $display("===== 무기 M16으로 변경 =====");
        BlackPink = m16;
        BlackPink.shot();
        $display("===== 무기 AUG으로 변경 =====");
        BlackPink = aug;
        BlackPink.shot();
        $display("===== 무기 k2으로 변경 =====");
        BlackPink = k2;
        BlackPink.shot();
    end
endmodule
