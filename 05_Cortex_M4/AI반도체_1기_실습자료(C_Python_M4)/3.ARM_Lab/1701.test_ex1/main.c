#include <stdio.h>

#include "device_driver.h"

void Main(void) {
    Macro_Set_Bit(RCC->AHB1ENR, 0);

    Macro_Write_Block(GPIOA->MODER, 0x3, 0x1, 10);
    Macro_Clear_Bit(GPIOA->OTYPER, 5);
    Macro_Clear_Bit(GPIOA->ODR, 5);

    Macro_Set_Bit(RCC->AHB1ENR, 2);
    Macro_Write_Block(GPIOC->MODER, 0x3, 0x00, 26);

    int key_cnt = 0;
    int led = 0;

    for (;;) {
        if (Macro_Check_Bit_Clear(GPIOC->IDR, 13)) {
            while (!(Macro_Check_Bit_Set(GPIOC->IDR, 13)));

            key_cnt++;

            if (key_cnt % 2 == 0) {
                key_cnt = 0;
                if (led) {
                    led = 0;
                    Macro_Clear_Bit(GPIOA->ODR, 5);
                } else {
                    Macro_Set_Bit(GPIOA->ODR, 5);
                    led = 1;
                }
            }
            printf("a:%d b:%d\n", key_cnt, led);
        }
    }
}