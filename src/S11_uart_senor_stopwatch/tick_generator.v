`timescale 1ns / 1ps

//CLK = 100MHz
//FREQUENCY = hz
module tick_gen  #(
    parameter CLK = 100_000_000,
    FREQUENCY = 100
) (
    input      clk,
    input      reset,
    input      i_run_stop,
    output reg o_tick_100hz
);
    parameter F_COUNT = CLK / FREQUENCY;
    reg [$clog2(F_COUNT)-1:0] counter_r;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_r <= 0;
            o_tick_100hz <= 1'b0;
        end else begin
            if (i_run_stop) begin
                counter_r <= counter_r + 1;
                o_tick_100hz <= 1'b0;
                if (counter_r == (F_COUNT - 1)) begin
                    counter_r <= 0;
                    o_tick_100hz <= 1'b1;
                end else begin
                    o_tick_100hz <= 1'b0;
                end
            end
        end
    end

endmodule