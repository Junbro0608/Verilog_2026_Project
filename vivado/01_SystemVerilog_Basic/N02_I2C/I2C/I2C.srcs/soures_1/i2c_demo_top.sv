module i2c_demo_top (
    input        clk,
    input        rst,
    input        btn_r,
    //I2C
    output logic scl,
    inout  wire  sda,
    //FND
    output logic fnd_data,
    output logic fnd_digit
);

    // command port
    logic        cmd_start;
    logic        cmd_write;
    logic        cmd_read;
    logic        cmd_stop;
    logic [ 7:0] tx_data;
    logic        ack_in;
    // internal output
    logic [ 7:0] rx_data;
    logic        done;
    logic        ack_out;
    logic        busy;

    logic [13:0] soc_data;



    //-----------slave---------------
    battery_ctrl U_BATTER_CTRL (
        //uesr
        .start   (btn_r),
        .soc_data(soc_data),
        //SPI interface
        .*
    );

    I2C_Master U_I2C_MASTER (.*);

    fnd_controller U_FND (
        .clk      (clk),
        .reset    (rst),
        .num      (soc_data),
        .fnd_data (fnd_data),
        .fnd_digit(fnd_digit)
    );

    //-----------slave---------------
    i2c_salve #(
        .SLA(7'h12)
    ) U_I2C_SLAVE (
        .*,
        // external port
        .tx_data(soc_int),
        .ack_in (slv_ack_in),
        .rx_data(slv_rx_data),
        .busy   (slv_busy),
        .done   (slv_done)
    );

    virtual_battery U_BATTERY (
        .clk      (clk),
        .rst      (rst),
        .charge_en(charge_en),  // 충전 모드
        .soc_int  (soc_int),    // 정수부 ~100
        .soc_dec  (),           // 소수부 두 자리까지
        .batt_low (),
        .batt_full()
    );

endmodule


