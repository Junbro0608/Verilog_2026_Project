`timescale 1ns / 1ps

module tb_spi_master_salve ();

    logic       clk;
    logic       reset;
    logic       cpol;
    logic       cpha;
    logic [7:0] clk_div;
    logic [7:0] tx_data;
    logic       start;
    logic [7:0] rx_data;
    logic m_done, s_done;
    logic busy;
    logic sclk;
    logic mosi;
    logic miso;
    logic cs_n;
    logic [7:0] slv_tx_data, slv_rx_data;

    always #5 clk = ~clk;

    spi_master dut_master (
        .clk    (clk),
        .reset  (reset),
        .cpol   (cpol),
        .cpha   (cpha),
        .clk_div(clk_div),
        .tx_data(tx_data),
        .start  (start),
        .rx_data(rx_data),
        .done   (m_done),
        .busy   (busy),
        .sclk   (sclk),
        .mosi   (mosi),
        .miso   (miso),
        .cs_n   (cs_n)
    );

    spi_slave dut_salve (
        .clk        (clk),
        .rst        (reset),
        //spi_protocals
        .sclk       (sclk),
        .cs_n       (cs_n),
        .mosi       (mosi),
        .miso       (miso),
        //slave I/O
        .slv_tx_data(slv_tx_data),
        .slv_rx_data(slv_rx_data),
        .done       (s_done)
    );

    task spi_set_mode(logic [1:0] mode);
        {cpol, cpha} = mode;
        @(posedge clk);
    endtask

    task spi_send_data(logic [7:0] data);
        tx_data = data;
        start   = 1'b1;
        @(posedge clk);
        start = 1'b0;
        @(posedge clk);
        wait (m_done);
        @(posedge clk);
    endtask

    task spi_get_data(logic [7:0] data);
        slv_tx_data = data;
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;
        @(posedge clk);
        wait (m_done);
        @(posedge clk);
    endtask

    initial begin
        clk   = 0;
        reset = 1;
        repeat (3) @(posedge clk);
        reset = 0;
        @(posedge clk);
        clk_div = 4;  //SCLK = 10Mhz -> ((100mhz / 10mhz * 2)) -1
        //miso = 1'b0;
        @(posedge clk);

        //master -> slave
        // spi_set_mode(0);
        // spi_send_data(8'h55);

        // spi_set_mode(1);
        // spi_send_data(8'h55);

        // spi_set_mode(2);
        // spi_send_data(8'h55);

        // spi_set_mode(3);
        // spi_send_data(8'h55);

        // master -> slave
        spi_set_mode(0);
        spi_get_data(8'haa);

        spi_set_mode(1);
        spi_get_data(8'haa);

        spi_set_mode(2);
        spi_get_data(8'haa);

        spi_set_mode(3);
        spi_get_data(8'haa);

        #20;
        $stop;
    end

endmodule
