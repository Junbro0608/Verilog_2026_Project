module clk_wiz_0 (
    input  logic clk_in1,  // 보드에서 들어오는 메인 클럭 (예: 100MHz)
    input  logic reset,    // 리셋 신호 (Active High 가정)
    output logic clk_out1, // 100MHz 출력 (시스템 클럭용)
    output logic clk_out2  // 25MHz 출력 (VGA 픽셀 클럭용)
);

    // 1. clk_out1 (100MHz): 입력 클럭을 그대로 바이패스 (Bypass)
    assign clk_out1 = clk_in1;

    // 2. clk_out2 (25MHz): 100MHz를 4분주 (Divide by 4)
    logic [1:0] div_cnt;

    always_ff @(posedge clk_in1 or posedge reset) begin
        if (reset) begin
            div_cnt <= 2'b00;
        end else begin
            div_cnt <= div_cnt + 1'b1;
        end
    end

    // 2비트 카운터(00 -> 01 -> 10 -> 11)의 최상위 비트(MSB)를 출력으로 사용하면,
    // 정확히 4클럭 주기로 한 번씩 토글되는 50% Duty Cycle의 25MHz 클럭이 생성됩니다.
    assign clk_out2 = div_cnt[1];

endmodule