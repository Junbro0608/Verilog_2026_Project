#include <stdio.h>

#include "device_driver.h"
volatile int TIM2_Expired = 0;
volatile int Key_Pressed = 0;
volatile int Uart_Data_In = 0;
volatile unsigned char Uart_Data = 0;

void Main(void) {
    Macro_Set_Bit(RCC->AHB1ENR, 0);

    Macro_Write_Block(GPIOA->MODER, 0x3, 0x1, 10);
    Macro_Clear_Bit(GPIOA->OTYPER, 5);
    Macro_Clear_Bit(GPIOA->ODR, 5);
    Macro_Set_Area(GPIOA->MODER, 0x1, 14);
    Macro_Clear_Bit(GPIOA->OTYPER, 7);
    Macro_Set_Bit(GPIOA->ODR, 7);

    Macro_Set_Bit(RCC->AHB1ENR, 2);
    Macro_Write_Block(GPIOC->MODER, 0x3, 0x00, 26);

    Macro_Set_Bit(RCC->AHB1ENR, 1);
    Macro_Write_Block(GPIOC->MODER, 0x3, 0x00, 14);
    Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x01, 14);

    int key_cnt = 0;

    for (;;) {
        if (Macro_Check_Bit_Clear(GPIOC->IDR, 13)) {
            while (!(Macro_Check_Bit_Set(GPIOC->IDR, 13)));

            key_cnt++;

            if (key_cnt == 1) {
                Macro_Set_Bit(GPIOA->ODR, 7);
                Macro_Set_Bit(GPIOA->ODR, 5);
            } else if (key_cnt == 2) {
                Macro_Clear_Bit(GPIOA->ODR, 7);
                Macro_Clear_Bit(GPIOA->ODR, 5);
            } else if (key_cnt == 3) {
                Macro_Set_Bit(GPIOA->ODR, 7);
                Macro_Set_Bit(GPIOA->ODR, 5);
            } else if (key_cnt == 4) {
                Macro_Clear_Bit(GPIOA->ODR, 7);
                Macro_Clear_Bit(GPIOA->ODR, 5);
                key_cnt = 0;
            }
        }

        if (Macro_Check_Bit_Clear(GPIOC->IDR, 7)) {
            while (!(Macro_Check_Bit_Set(GPIOC->IDR, 7)));

            Macro_Set_Bit(GPIOA->ODR, 7);
            Macro_Clear_Bit(GPIOA->ODR, 5);
        }
    }
}
