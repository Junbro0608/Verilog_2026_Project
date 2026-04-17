`timescale 1ns / 1ps

module tb_i2c_master ();

    logic       clk;
    logic       rst;
    // command port
    logic       cmd_start;
    logic       cmd_write;
    logic       cmd_read;
    logic       cmd_stop;
    logic [7:0] tx_data;
    logic       ack_in;
    // internal output
    logic [7:0] rx_data;
    logic       done;
    logic       ack_out;
    logic       busy;
    // external port
    logic       scl;
    wire        sda;

    logic [7:0] slv_tx_data, slv_rx_data;
    logic slv_busy, slv_done;
    logic slv_ack_in;

    localparam SLA = 8'h12;

    pullup (sda);


    I2C_Master DUT (
        .*,
        .scl(scl),
        .sda(sda)
    );

    i2c_salve #(
        .SLA(7'h12)
    ) U_I2C_SLV (
        .*,
        .ack_in (slv_ack_in),
        .tx_data(slv_tx_data),
        .rx_data(slv_rx_data),
        .busy   (slv_busy),
        .done   (slv_done)
    );

    always #5 clk = ~clk;

    task i2c_start();
        cmd_start = 1'b1;
        cmd_write = 1'b0;
        cmd_read  = 1'b0;
        cmd_stop  = 1'b0;
        @(posedge clk);
        wait (done);
        @(posedge clk);
    endtask

    task i2c_addr(byte addr);
        slv_ack_in = 1;
        tx_data    = addr;
        cmd_start  = 1'b0;
        cmd_write  = 1'b1;
        cmd_read   = 1'b0;
        cmd_stop   = 1'b0;
        @(posedge clk);
        wait (done);  // wait ack
        @(posedge clk);
    endtask

    task i2c_write(byte data, logic nack);
        tx_data    = data;
        slv_ack_in = nack;
        cmd_start  = 1'b0;
        cmd_write  = 1'b1;
        cmd_read   = 1'b0;
        cmd_stop   = 1'b0;
        @(posedge clk);
        wait (done);  // wait ack
        @(posedge clk);
    endtask

    task i2c_read(logic nack);
        ack_in    = nack;
        cmd_start = 1'b0;
        cmd_write = 1'b0;
        cmd_read  = 1'b1;
        cmd_stop  = 1'b0;
        @(posedge clk);
        wait (done);  // wait ack
        @(posedge clk);
    endtask
    task i2c_stop();
        cmd_start = 1'b0;
        cmd_write = 1'b0;
        cmd_read  = 1'b0;
        cmd_stop  = 1'b1;
        @(posedge clk);
        wait (done);
        @(posedge clk);
    endtask

    logic [7:0] num;
    always @(posedge slv_done) begin
        slv_tx_data <= num;
        num <= num + 1;
    end

    initial begin
        num = 8'h55;

        clk = 0;
        rst = 1;
        repeat (3) @(posedge clk);
        rst = 0;
        ack_in = 1;
        @(posedge clk);

        i2c_start();
        i2c_addr((SLA << 1) + 1'b0);
        i2c_write(8'h55, 1);
        i2c_write(8'haa, 1);
        i2c_write(8'h01, 1);
        i2c_write(8'h02, 1);
        i2c_write(8'h03, 1);
        i2c_write(8'h04, 1);
        i2c_write(8'h05, 1);
        i2c_write(8'h06, 1);
        i2c_write(8'hff, 0);
        i2c_stop();
        repeat (50) @(posedge clk);
        ack_in = 1'b1;
        i2c_start();
        i2c_addr((SLA << 1) + 1'b1);
        i2c_read(1);
        i2c_read(1);
        i2c_read(1);
        i2c_read(0);
        wait (done);
        i2c_stop();

        #100;
        $finish;
    end
endmodule
