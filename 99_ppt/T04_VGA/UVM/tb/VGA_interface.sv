`ifndef IF_SV
`define IF_SV

interface VGA_if (
    input logic clk,
    input logic rst
);
    // OV7670
    logic       pclk;
    logic       xclk;
    logic       href;
    logic       vsync;
    logic [7:0] pdata;
    
    // VGA
    logic [3:0] port_red;
    logic [3:0] port_green;
    logic [3:0] port_blue;
    logic       h_sync;
    logic       v_sync;
    
    // ==========================================
    // 💡 I2C 신호 (tri1 사용으로 Pull-up 저항 모방)
    // ==========================================
    tri1        scl_s;
    tri1        sda_s; 

    // 동기식 구동을 위한 Clocking Block (I2C 제외)
    clocking drv_cb @(posedge clk);
        default input #1step output #0;
        output pclk;
        input  xclk;
        output href;
        output vsync;
        output pdata;
    endclocking

    // 동기식 관찰을 위한 Clocking Block (I2C 제외)
    clocking mon_cb @(posedge clk);
        default input #1step;
        // OV7670
        input pclk;
        input xclk;
        input href;
        input vsync;
        input pdata;
        // VGA
        input port_red;
        input port_green;
        input port_blue;
        input h_sync;
        input v_sync;
    endclocking

    modport mp_drv(clocking drv_cb, input clk, input rst);
    modport mp_mon(clocking mon_cb, input clk, input rst);
    
endinterface

`endif