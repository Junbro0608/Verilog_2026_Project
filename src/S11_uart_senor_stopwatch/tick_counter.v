// msec, sec, min, hour
// tick counter
module tick_counter #(
    parameter BIT_WIDTH = 7,
    TIMES = 100,
    INIT_TIME = 0
) (
    input                      clk,
    input                      reset,
    input                      i_tick,
    input                      down_up,
    input                      clear,
    input                      run_stop,
    output     [BIT_WIDTH-1:0] o_count,
    output reg                 o_tick
);

    //counter reg
    reg [BIT_WIDTH-1:0] counter_reg, counter_next;

    assign o_count = counter_reg;
    //State reg SL
    always @(posedge clk, posedge reset) begin
        if (reset | clear) begin
            counter_reg <= INIT_TIME;
        end else begin
            counter_reg <= counter_next;
        end
    end

    //next CL
    always @(*) begin
        counter_next = counter_reg;
        o_tick = 1'b0;
        if (i_tick & run_stop) begin
            if (down_up == 1'b1) begin
                //down
                if (counter_reg == 0) begin
                    counter_next = TIMES - 1;
                    o_tick = 1'b1;
                end else begin
                    counter_next = counter_reg - 1;
                    o_tick = 1'b0;
                end
            end else begin
                //up
                if (counter_reg == TIMES - 1) begin
                    counter_next = 0;
                    o_tick = 1'b1;
                end else begin
                    counter_next = counter_reg + 1;
                    o_tick = 1'b0;
                end
            end
        end
    end

endmodule
