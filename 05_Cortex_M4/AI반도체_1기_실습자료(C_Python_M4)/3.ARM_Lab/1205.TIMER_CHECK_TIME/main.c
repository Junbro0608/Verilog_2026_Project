#include <stdio.h>

#include "device_driver.h"

static void Sys_Init(int baud) {
    SCB->CPACR |= (0x3 << 10 * 2) | (0x3 << 11 * 2);
    Clock_Init();
    Uart2_Init(baud);
    setvbuf(stdout, NULL, _IONBF, 0);
    LED_Init();
}

volatile int Key_Pressed = 0;
volatile int Uart_Data_In = 0;
volatile unsigned char Uart_Data = 0;
volatile int TIM4_Expired = 0;

void Main(void) {
    Sys_Init(115200);
    printf("\nTimer 4 Interrupt Test\n");

    Key_ISR_Enable(1);
    Uart2_RX_Interrupt_Enable(1);
    TIM4_Repeat_Interrupt_Enable(1, 100);
    int cnt = 0;
    int d = 0;
    int check_time_flag = 0;

    for (;;) {
        if (Key_Pressed) {
            if (check_time_flag) {
                printf("time : %.1f sec\n", (cnt / 10.0));
                check_time_flag = 0;
            } else {
                check_time_flag = 1;
            }

            printf("KEY Pressed!!!\n");
            Key_Pressed = 0;
        }

        if (Uart_Data_In) {
            printf("RX Data = %c\n", Uart_Data);
            Uart_Data_In = 0;
        }

        if (TIM4_Expired) {
            if (check_time_flag == 0) {
                cnt = 0;
            } else {
                cnt++;
            }

            (d ^= 1) ? LED_On() : LED_Off();
            TIM4_Expired = 0;
        }
    }
}
