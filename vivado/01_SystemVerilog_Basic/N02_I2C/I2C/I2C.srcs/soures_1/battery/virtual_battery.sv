module virtual_battery (
    input              clk,
    input              rst,
    input              charge_en,  // 충전 모드
    output logic [6:0] soc_int,    // 정수부 ~100
    output logic [6:0] soc_dec,    // 소수부 두 자리까지
    output logic       batt_low,
    output logic       batt_full
);

    logic [23:0] timer_cnt;
    localparam TARGET_CNT = 24'd10_000_000 - 1;

    logic [13:0] soc_raw;

    // 0.1sec Counter
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            timer_cnt <= 24'd0;
        end else begin
            if (timer_cnt >= TARGET_CNT) timer_cnt <= 24'd0;
            else timer_cnt <= timer_cnt + 1'b1;
        end
    end

    //Soc 충방전
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            soc_raw <= 14'd5000;  // init 50%
        end else if (timer_cnt == TARGET_CNT) begin
            if (charge_en && (soc_raw < 14'd10000)) begin
                soc_raw <= soc_raw + 14'd1;  // 0.01% ++
            end else if (!charge_en && (soc_raw > 14'd0)) begin
                soc_raw <= soc_raw - 14'd1;  // 0.01% --
            end
        end
    end


    assign soc_int   = soc_raw / 100;  // 정수부
    assign soc_frac  = soc_raw % 100;  // 소수부

    assign batt_full = (soc_raw >= 14'd10000);
    assign batt_low  = (soc_raw <= 14'd2000);

endmodule
