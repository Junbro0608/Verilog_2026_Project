`timescale 1ns / 1ps


module fiforegister #(
    parameter ADDR = 0,
    parameter BIT_WIDTH = 8
) (
    input                        w_clk,
    input                        r_clk,
    input                        rst,
    input                        we,
    input        [BIT_WIDTH-1:0] wdata,
    input                        re,
    output logic [BIT_WIDTH-1:0] rdata,
    output logic [BIT_WIDTH-1:0] full,
    output logic [BIT_WIDTH-1:0] empty
);
    fifo_controller #(
        .ADDR     (ADDR),
        .BIT_WIDTH(BIT_WIDTH)
    ) U_FIFO_CTLR (
        .w_clk(w_clk),
        .r_clk(r_clk),
        .rst  (rst),
        .we   (we),
        .re   (re),
        .wptr (wptr),
        .rptr (rptr),
        .full (full),
        .empty(empty)
    );

    sram #(
        .ADDR     (ADDR),
        .BIT_WIDTH(BIT_WIDTH)
    ) U_SRAM (
        .clk   (w_clk),
        .we    (we && ~full),
        .w_addr(wptr),
        .r_addr(rptr),
        .wdata (wdata),
        .rdata (rdata)
    );




endmodule

module fifo_controller #(
    parameter ADDR = 16,
    parameter BIT_WIDTH = 8
) (
    input                           w_clk,
    input                           r_clk,
    input                           rst,
    input                           we,
    input                           re,
    output logic [$clog2(ADDR)-1:0] wptr,
    output logic [$clog2(ADDR)-1:0] rptr,
    output logic [   BIT_WIDTH-1:0] full,
    output logic [   BIT_WIDTH-1:0] empty
);


    always_ff @(posedge w_clk or posedge rst) begin : fifo_ctrl_w_ff
        if (rst) begin
            wptr  <= 1'b0;
            full  <= 1'b0;
            empty <= 1'b1;
        end else begin
            if (we && re) begin
                wptr <= wptr + 1;
            end else if (we) begin
                wptr  <= wptr + 1;
                empty <= 0;
                full  <= (wptr == rptr);
            end
        end
    end

    always_ff @(posedge r_clk or posedge rst) begin : fifo_ctrl_r_ff
        if (rst) begin
            rptr  <= 1'b0;
            full  <= 1'b0;
            empty <= 1'b1;
        end else begin
            if (we && re) begin
                rptr <= rptr + 1;
            end else if (re) begin
                rptr  = rptr + 1;
                empty = (wptr == rptr);
                full  = 0;
            end
        end
    end


endmodule


`timescale 1ns / 1ps

module sram #(
    parameter ADDR = 16,
    parameter BIT_WIDTH = 8
) (
    input                           clk,
    input                           we,
    input        [$clog2(ADDR)-1:0] w_addr,
    input        [$clog2(ADDR)-1:0] r_addr,
    input        [   BIT_WIDTH-1:0] wdata,
    output logic [   BIT_WIDTH-1:0] rdata
);

    logic [BIT_WIDTH-1:0] sram_reg[0:ADDR-1];

    always_ff @(posedge clk) begin : sram_wdata
        if (we) begin
            sram_reg[w_addr] <= wdata;
        end
    end

    assign rdata = sram_reg[r_addr];
endmodule
