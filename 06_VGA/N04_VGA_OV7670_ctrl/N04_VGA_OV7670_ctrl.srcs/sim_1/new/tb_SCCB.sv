`timescale 1ns / 1ps

module tb_SCCB;

    // 신호 선언
    logic       clk;
    logic       reset;
    logic       start;
    logic       write;
    logic [7:0] fsm_addr;
    logic [7:0] fsm_wdata;
    logic [7:0] fsm_rdata;
    logic       ready;
    logic       scl;
    wire        sda;

    // 🌟 핵심 해결책: I2C/SCCB 버스에는 반드시 하드웨어 풀업이 있어야 합니다.
    // 마스터가 1'bz(릴리즈) 상태일 때 자동으로 1로 당겨주는 역할을 합니다.
    pullup (sda);

    // 가상 슬레이브 드라이버 신호
    logic sda_out;
    logic slave_en;
    
    // Open-Drain 방식으로 슬레이브 구동 (0일 때만 밀고, 1일 때는 놔주기)
    assign sda = (slave_en && (sda_out == 1'b0)) ? 1'b0 : 1'bz;

    // DUT 인스턴스화
    SCCB uut (
        .clk      (clk),
        .reset    (reset),
        .start    (start),
        .write    (write),
        .fsm_addr (fsm_addr),
        .fsm_wdata(fsm_wdata),
        .fsm_rdata(fsm_rdata),
        .ready    (ready),
        .scl      (scl),
        .sda      (sda)
    );

    // 100MHz 클럭 생성 (10ns 주기)
    always #5 clk = ~clk;

    initial begin
        // 초기화
        clk       = 0;
        reset     = 1;
        start     = 0;
        write     = 0;
        fsm_addr  = 8'h00;
        fsm_wdata = 8'h00;
        slave_en  = 0;
        sda_out   = 1;

        // 리셋 해제
        #40;
        reset = 0;
        #20;

        // ==========================================
        // 1. TX TEST (Write 동작: Reg 0x07에 0x55 쓰기)
        // ==========================================
        $display("[TB] Start TX (Write) Test...");
        @(posedge clk);
        while (!ready) @(posedge clk); 

        start     = 1;
        write     = 1;         
        fsm_addr  = 8'h07;     
        fsm_wdata = 8'h55;     
        
        @(posedge clk);
        start     = 0;         

        // FSM 완료 대기
        @(posedge clk);
        while (!ready) @(posedge clk);
        $display("[TB] TX Test Completed.\n");
        #200;

        // ==========================================
        // 2. RX TEST (Read 동작: Reg 0x07 읽기 시도)
        // ==========================================
        $display("[TB] Start RX (Read) Test...");
        
        fork
            begin
                start     = 1;
                write     = 0;         // Read Mode
                fsm_addr  = 8'h07;     
                @(posedge clk);
                start     = 0;
            end
            begin
                // 가상 슬레이브 타이밍 제어
                // U_I2C_MASTER_CORE의 동작 속도에 맞춰 이 딜레이(#)값을 조절해야 합니다.
                // SCL이 흔들리며 Read Data를 가져가는 순간에 매칭되어야 합니다.
                #600; 
                slave_en = 1;
                
                // 가상 데이터 8'hA5 (10100101) 전송 시뮬레이션
                sda_out = 1; #100; // Bit 7
                sda_out = 0; #100; // Bit 6
                sda_out = 1; #100; // Bit 5
                sda_out = 0; #100; // Bit 4
                sda_out = 0; #100; // Bit 3
                sda_out = 1; #100; // Bit 2
                sda_out = 0; #100; // Bit 1
                sda_out = 1; #100; // Bit 0
                
                slave_en = 0;      // 마스터가 ACK/NACK 보낼 수 있도록 버스 릴리즈
            end
        join

        // 완료 대기
        @(posedge clk);
        while (!ready) @(posedge clk);
        
        $display("[TB] RX Test Completed. Read Data = 8'h%h", fsm_rdata);
        
        #200;
        $finish;
    end

endmodule