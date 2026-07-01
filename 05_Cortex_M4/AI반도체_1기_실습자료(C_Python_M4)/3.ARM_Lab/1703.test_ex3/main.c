#include <stdio.h>

#include "device_driver.h"

volatile int TIM2_Expired = 0;
volatile int Key_Pressed = 0;
volatile int Uart_Data_In = 0;
volatile unsigned char Uart_Data = 0;

#define TIM4_TICK        (20)                   // usec
#define TIM4_FREQ        (1000000 / TIM4_TICK)  // Hz
#define TIME4_PLS_OF_1ms (1000 / TIM4_TICK)
#define TIM4_MAX         (0xffffu)

static void Sys_Init(int baud) {
    SCB->CPACR |= (0x3 << 10 * 2) | (0x3 << 11 * 2);
    Clock_Init();
    Uart2_Init(baud);
    setvbuf(stdout, NULL, _IONBF, 0);
    // LED_Init();
}

void Main(void) {
    Sys_Init(115200);
    printf("\ntest3\n");
    Uart1_Init(115200);
    //--------timer_init---------------
    int time = 1000;

    Macro_Set_Bit(RCC->APB1ENR, 2);
    TIM4->CR1 = (1 << 4) | (0 << 3);
    TIM4->PSC = (unsigned int)(TIMXCLK / (double)TIM4_FREQ + 0.5) - 1;
    TIM4->ARR = TIME4_PLS_OF_1ms * time - 1;

    Macro_Set_Bit(TIM4->EGR, 0);
    Macro_Clear_Bit(TIM4->SR, 0);
    Macro_Set_Bit(TIM4->CR1, 0);

    Macro_Set_Bit(RCC->AHB1ENR, 0);
    Macro_Write_Block(GPIOA->MODER, 0x3, 0x1, 10);
    Macro_Clear_Bit(GPIOA->OTYPER, 5);
    Macro_Clear_Bit(GPIOA->ODR, 5);

    int perv_time = 0;
    int cur_time = 0;
    int led = 0;
    char c;
    int uart_flag = 0;

    for (;;) {
        // uart
        if (uart_flag == 0) {
            if (Macro_Check_Bit_Set(USART1->SR, 5)) {
                c = USART1->DR;
                uart_flag = 1;
            }
        } else {
            if (Macro_Check_Bit_Set(USART1->SR, 7)) {
                USART1->DR = c + 1;
                uart_flag = 0;
                printf("%c ", c);
            }
        }
        // led
        if (cur_time != perv_time) {
            if (led == 0) {
                Macro_Set_Bit(GPIOA->ODR, 5);
                led = 1;
            } else {
                Macro_Clear_Bit(GPIOA->ODR, 5);
                led = 0;
            }
            perv_time = cur_time;
        }
        // time
        if (Macro_Check_Bit_Set(TIM4->SR, 0)) {
            Macro_Clear_Bit(TIM4->SR, 0);
            cur_time++;
        }
    }
}
