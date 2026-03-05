`timescale 1ns / 1ps


module control_unit (
    input        clk,
    input        rst,
    input        i_btn_l,
    input        i_btn_r,
    input        i_btn_u,
    input        i_btn_d,
    input  [1:0] i_mode,
    input        i_sw_up_down,
    output [1:0] o_clear,
    output       o_run_stop,
    output       o_down_up,
    output [1:0] o_time_modify,
    output [1:0] o_mode,
    output       o_sr04_auto,
    output       o_sr04_start,
    output       o_dht11_auto,
    output       o_dht11_start,
    output [2:0] test_mode
);


    //mode=> 0: stopwatch 1: watch
    //----------------------stopwatch--------------------
    //clear=> 0: off 1: on
    //run_stop=> 0: stop 1:run
    //down_up=> 0: up 1:down
    //----------------------watch--------------------
    //time_modify=> [0]:minus [1] plus

    localparam [3:0] IDLE = 0, 
                    STOPWATCH_CLEAR = 1,STOPWATCH_STOP=2, STOPWATCH_RUN=3, 
                    WATCH = 4, 
                    SR04=5, 
                    DHT11=6;

    reg [2:0] c_state, n_state;
    reg [1:0] clear_reg, clear_next;
    reg run_stop_reg, run_stop_next;
    reg down_up_reg, down_up_next;
    reg [1:0] time_modify_reg, time_modify_next;
    reg [1:0] mode_next, mode_reg;
    reg sr04_auto_next, sr04_auto_reg;
    reg sr04_start_next, sr04_start_reg;
    reg dht11_auto_next, dht11_auto_reg;
    reg dht11_start_next, dht11_start_reg;

    assign o_clear = clear_reg;
    assign o_run_stop = run_stop_reg;
    assign o_down_up  = down_up_reg;
    assign o_time_modify = time_modify_reg;
    assign o_mode    = mode_reg;
    assign o_sr04_auto = sr04_auto_reg;
    assign o_sr04_start = sr04_start_reg;
    assign o_dht11_auto = dht11_auto_reg;
    assign o_dht11_start = dht11_start_reg;


    assign test_mode = c_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_state         <= IDLE;
            clear_reg       <= 2'b0;
            run_stop_reg    <= 1'b0;
            down_up_reg     <= 1'b0;
            time_modify_reg <= 2'b0;
            mode_reg        <= 2'b0;
            sr04_auto_reg   <= 1'b0;
            sr04_start_reg  <= 1'b0;
            dht11_auto_reg  <= 1'b0;
            dht11_start_reg <= 1'b0;
        end else begin
            c_state         <= n_state;
            clear_reg       <= clear_next;
            run_stop_reg    <= run_stop_next;
            down_up_reg     <= down_up_next;
            time_modify_reg <= time_modify_next;
            mode_reg        <= mode_next;
            sr04_auto_reg   <= sr04_auto_next;
            sr04_start_reg  <= sr04_start_next;
            dht11_auto_reg  <= dht11_auto_next;
            dht11_start_reg <= dht11_start_next;
        end
    end

    //move state
    always @(*) begin
        n_state = c_state;
        case (c_state)
            IDLE: begin
                if (i_btn_d) begin
                    if (i_mode == 2'd0) begin
                        n_state = STOPWATCH_CLEAR;
                    end else if (i_mode == 2'd1) begin
                        n_state = WATCH;
                    end else if (i_mode == 2'd2) begin
                        n_state = SR04;
                    end else if (i_mode == 2'd3) begin
                        n_state = DHT11;
                    end
                end
            end
            STOPWATCH_CLEAR: begin
                n_state = STOPWATCH_STOP;
            end
            STOPWATCH_STOP: begin
                if (i_btn_d) begin
                    if (i_mode == 2'd1) begin
                        n_state = WATCH;
                    end else if (i_mode == 2'd2) begin
                        n_state = SR04;
                    end else if (i_mode == 2'd3) begin
                        n_state = DHT11;
                    end
                end else if (i_btn_l) begin
                    n_state = STOPWATCH_CLEAR;
                end else if (i_btn_r) begin
                    n_state = STOPWATCH_RUN;
                end
            end
            STOPWATCH_RUN: begin
                if (i_btn_d) begin
                    if (i_mode == 2'd0) begin
                        n_state = STOPWATCH_CLEAR;
                    end else if (i_mode == 2'd1) begin
                        n_state = WATCH;
                    end else if (i_mode == 2'd2) begin
                        n_state = SR04;
                    end else if (i_mode == 2'd3) begin
                        n_state = DHT11;
                    end
                end else if (i_btn_l) begin
                    n_state = STOPWATCH_CLEAR;
                end else if (i_btn_r) begin
                    n_state = STOPWATCH_STOP;
                end
            end
            WATCH: begin
                if (i_btn_d) begin
                    if (i_mode == 2'd0) begin
                        n_state = STOPWATCH_CLEAR;
                    end else if (i_mode == 2'd2) begin
                        n_state = SR04;
                    end else if (i_mode == 2'd3) begin
                        n_state = DHT11;
                    end
                end
            end
            SR04: begin
                if (i_btn_d) begin
                    if (i_mode == 2'd0) begin
                        n_state = STOPWATCH_CLEAR;
                    end else if (i_mode == 2'd1) begin
                        n_state = WATCH;
                    end else if (i_mode == 2'd3) begin
                        n_state = DHT11;
                    end
                end
            end
            DHT11: begin
                if (i_btn_d) begin
                    if (i_mode == 2'd0) begin
                        n_state = STOPWATCH_CLEAR;
                    end else if (i_mode == 2'd1) begin
                        n_state = WATCH;
                    end else if (i_mode == 2'd2) begin
                        n_state = SR04;
                    end
                end
            end
        endcase
    end

    //output
    //mode=> 0: stopwatch 1: watch
    //----------------------stopwatch--------------------
    //clear=> [0]: clear stopwatch 1: clear watch
    //run_stop=> 0: stop 1:run
    //down_up=> 0: up 1:down
    //----------------------watch--------------------
    //time_modify=> [0]:minus [1] plus
    always @(*) begin
        clear_next       = clear_reg;
        run_stop_next    = run_stop_reg;
        down_up_next     = down_up_reg;
        time_modify_next = time_modify_reg;
        mode_next        = mode_reg;
        sr04_auto_next   = sr04_auto_reg;
        sr04_start_next  = sr04_start_reg;
        dht11_auto_next  = dht11_auto_reg;
        dht11_start_next = dht11_start_reg;
        //mode_reg : fnd input data mux4x1 sel
        if (c_state == DHT11) begin
            mode_next = 2'd3;
        end else if (c_state == SR04) begin
            mode_next = 2'd2;
        end else if (c_state == WATCH) begin
            mode_next = 2'd1;
        end else begin
            mode_next = 2'd0;
        end


        if (c_state == WATCH) begin
            mode_next = 1'b1;
        end else begin
            mode_next = 1'b0;
            if (i_btn_l) begin
                clear_next = 2'b1;
            end
        end
        //other
        case (c_state)
            IDLE: begin
                clear_next    = 2'b11;
                run_stop_next = 1'b0;
                down_up_next  = 1'b0;
                time_modify_next = 2'b0;
            end
            STOPWATCH_CLEAR: begin
                clear_next = 2'b01;
            end
            STOPWATCH_STOP: begin
                clear_next    = 2'b0;
                run_stop_next = 1'b0;
                if ((i_sw_up_down == 0) && (i_btn_u)) begin
                    down_up_next = ~down_up_reg;
                end
                time_modify_next = 2'b0;
            end
            STOPWATCH_RUN: begin
                clear_next    = 2'b0;
                run_stop_next = 1'b1;
                if (i_btn_u) begin
                    if (i_sw_up_down == 0) begin
                        down_up_next = 1'b1;  //down count
                    end else begin
                        down_up_next = 1'b0;  //up count
                    end
                end
                time_modify_next = 2'b0;
            end
            WATCH: begin
                //clear
                if (i_btn_l) begin
                    clear_next = 2'b11;
                end else begin
                    clear_next = 2'b01;
                end
                run_stop_next = 1'b0;
                down_up_next  = 1'b0;
                //set time
                if (i_btn_u) begin
                    if (i_sw_up_down == 0) begin
                        time_modify_next = 2'b01;  //set min --
                    end else begin
                        time_modify_next = 2'b10;  //set min ++
                    end
                end else begin
                    time_modify_next = 2'b0;
                end
            end
            SR04: begin
                if (i_btn_u) begin
                    sr04_auto_next = ~sr04_auto_reg;
                end else if ((sr04_auto_reg != 1) && (i_btn_r)) begin
                    sr04_start_next = 1'b1;
                end else begin
                    sr04_start_next = 1'b0;
                end
            end
            DHT11: begin
                if (i_btn_u) begin
                    dht11_auto_next = ~dht11_auto_reg;
                end else if ((sr04_auto_reg != 1) && (i_btn_r)) begin
                    dht11_start_next = 1'b1;
                end else begin
                    dht11_start_next = 1'b0;
                end
            end
        endcase
    end


endmodule
