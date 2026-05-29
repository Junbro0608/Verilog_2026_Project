#include <stdio.h>

#include "device_driver.h"

volatile int TIM2_Expired = 0;
volatile int Key_Pressed = 0;
volatile int Uart_Data_In = 0;
volatile unsigned char Uart_Data = 0;

static void Sys_Init(int baud) {
    SCB->CPACR |= (0x3 << 10 * 2) | (0x3 << 11 * 2);
    Clock_Init();
    Uart2_Init(baud);
    setvbuf(stdout, NULL, _IONBF, 0);
    // LED_Init();
}

#define TIM4_TICK        (20)                   // usec
#define TIM4_FREQ        (1000000 / TIM4_TICK)  // Hz
#define TIME4_PLS_OF_1ms (1000 / TIM4_TICK)
#define TIM4_MAX         (0xffffu)

void init_TIM4(int time) {
    Macro_Set_Bit(RCC->APB1ENR, 2);
    TIM4->CR1 = (1 << 4) | (0 << 3);
    TIM4->PSC = (unsigned int)(TIMXCLK / (double)TIM4_FREQ + 0.5) - 1;
    TIM4->ARR = TIME4_PLS_OF_1ms * time - 1;

    Macro_Set_Bit(TIM4->EGR, 0);
    Macro_Clear_Bit(TIM4->SR, 0);
    Macro_Set_Bit(TIM4->CR1, 0);
}

void Main(void) {
    Sys_Init(115200);
    printf("Test start\n");

    init_TIM4(1000);

    Macro_Set_Bit(TIM4->EGR, 0);
    Macro_Clear_Bit(TIM4->SR, 0);
    Macro_Set_Bit(TIM4->CR1, 0);

    Macro_Set_Bit(RCC->AHB1ENR, 0);
    Macro_Write_Block(GPIOA->MODER, 0x3, 0x1, 10);
    Macro_Clear_Bit(GPIOA->OTYPER, 5);
    Macro_Clear_Bit(GPIOA->ODR, 5);

    Macro_Set_Bit(RCC->AHB1ENR, 2);
    Macro_Write_Block(GPIOC->MODER, 0x3, 0x00, 26);

    Macro_Set_Bit(RCC->AHB1ENR, 1);
    Macro_Write_Block(GPIOC->MODER, 0x3, 0x00, 14);
    Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x01, 14);

    int next_mode, mode = 0;
    int done = 0;
    int mode_chage = 0;
    int perv_time = 0;
    int cur_time = 0;
    int sw_out = 0;
    int sw_in = 0;
    int led = 0;
    for (;;) {
        if (cur_time != perv_time) {
            perv_time = cur_time;
            // sw
            if (sw_in) {
                next_mode = 1;
                sw_in = 0;
                mode_chage = 1;

            } else if (sw_out) {
                next_mode = 0;
                sw_out = 0;
                mode_chage = 1;
            }
            // mode
            if ((mode_chage == 1) && (done == 1)) {
                mode = next_mode;
            }
            // led
            if (mode == 0) {
                if (led == 0) {
                    Macro_Set_Bit(GPIOA->ODR, 5);
                    led = 1;
                    done = 0;
                } else {
                    Macro_Clear_Bit(GPIOA->ODR, 5);
                    led = 0;
                    done = 1;
                }
            } else {
                if (cur_time % 4 == 0) {
                    cur_time = 0;
                    if (led == 0) {
                        Macro_Set_Bit(GPIOA->ODR, 5);
                        led = 1;
                        done = 0;
                    } else {
                        Macro_Clear_Bit(GPIOA->ODR, 5);
                        led = 0;
                        done = 1;
                    }
                }
            }
        }

        if (sw_in == 0) {
            if (Macro_Check_Bit_Clear(GPIOC->IDR, 13)) {
                sw_in = 1;
            }
        }
        if (sw_out == 0) {
            if (Macro_Check_Bit_Clear(GPIOC->IDR, 7)) {
                sw_out = 1;
            }
        }

        // time
        if (Macro_Check_Bit_Set(TIM4->SR, 0)) {
            Macro_Clear_Bit(TIM4->SR, 0);
            cur_time++;
            printf(".");
        }
    }
}
