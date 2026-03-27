`timescale 1ns / 1ps
//multi_cycle CPU + interrupt I/O
interface apb_if;
    logic [31:0] PRDATA;
    logic        PSEL;
    logic        PREADY;

    // Slave I/O
    modport master_io(input PRDATA, PREADY, output PSEL);
    modport slave_io(input PSEL, output PRDATA, PREADY);
endinterface

module rv32I_mcu (
    input         clk,
    input         rst,
    //IO
    input  [ 7:0] gpi,
    output [ 7:0] gpo,
    inout  [15:0] gpio,
    //FND
    output [ 7:0] fnd_data,
    output [ 3:0] fnd_digit
);
    logic [31:0] instr_addr, instr_data;
    logic bus_wreq, bus_rreq, ready;
    logic [31:0] bus_addr, bus_wdata, bus_rdata;
    logic [2:0] o_funct3;
    logic PENABLE, PWRITE;
    logic [31:0] PADDR, PWDATA;
    logic [7:0] FND_slv_data;


    apb_if
        slv_RAM (),
        slv_GPO (),
        slv_GPI (),
        slv_GPIO (),
        slv_FND (),
        slv_UART ();

    instruction_mem U_INSTR_MEM (
        .instr_addr(instr_addr[31:2]),
        .instr_data(instr_data)
    );

    rv32i_cpu U_CPU (.*);

    // data_mem U_DATA_MEM (
    //     .*,
    //     .i_funct3(o_funct3)
    // );

    apb_master U_APB_MASTER (
        .PCLK    (clk),
        .PRESET  (rst),
        //Soc Internal signal with CPU
        .addr    (bus_addr),
        .Wdata   (bus_wdata),
        .Wreq    (bus_wreq),
        .Rreq    (bus_rreq),
        //APB Interface
        // output logic                  slvERR,
        .Rdata   (bus_rdata),
        .ready   (ready),
        //output -> salve
        .PADDR   (PADDR),
        .PWDATA  (PWDATA),
        .PENABLE (PENABLE),
        .PWRITE  (PWRITE),
        .slv_RAM (slv_RAM),
        .slv_GPO (slv_GPO),
        .slv_GPI (slv_GPI),
        .slv_GPIO(slv_GPIO),
        .slv_FND (slv_FND),
        .slv_UART(slv_UART)
    );

    apb_slave_dram U_SLV_DRAM (
        .PCLK  (clk),
        //cpu
        .funct3(o_funct3),
        //APB_bus
        .*
    );

    apb_slave_gpo U_SLV_GPO (
        .PCLK  (clk),
        .PRESET(rst),
        //APB_bus
        .*,
        //output
        .GPO_out   (gpo)
    );

    apb_slave_gpi U_SLV_GPI (
        .PCLK  (clk),
        .PRESET(rst),
        //APB_bus
        .*,
        //input
        .GPI_in(gpi)
    );

    apb_slave_GPIO U_SLV_GPIO (
        .PCLK   (clk),
        .PRESET (rst),
        //APB_bus
        .*,
        //inout
        .GPIO_io(gpio)
    );

    apb_slave_FND U_SLV_FND (
        .PCLK   (clk),
        .PRESET (rst),
        //APB_bus
        .*,
        //output
        .FND_slv_data(FND_slv_data)
    );

    fnd_controller U_FND (
        .clk      (clk),
        .reset    (rst),
        .d_in     (FND_slv_data),
        .fnd_data (fnd_data),
        .fnd_digit(fnd_digit)
    );

endmodule
