#include "device_driver.h"

static int led = 0;

void LED_Init(void) {
    /* 아래 코드 수정 금지 : Port-A Clock Enable */
    Macro_Set_Bit(RCC->AHB1ENR, 0);

    // LED를 출력으로 설정하고 초기 OFF
    Macro_Write_Block(GPIOA->MODER, 0x3, 0x01, 10);
    Macro_Set_Area(GPIOA->MODER, 0x1, 12);
    Macro_Set_Area(GPIOA->MODER, 0x1, 14);

    Macro_Clear_Bit(GPIOA->OTYPER, 5);
    Macro_Clear_Bit(GPIOA->OTYPER, 6);
    Macro_Clear_Bit(GPIOA->OTYPER, 7);
}

void LED_On(int pin) {
    // LED On
    Macro_Set_Bit(GPIOA->ODR, pin);
}

void LED_Off(int pin) {
    // LED Off
    Macro_Clear_Bit(GPIOA->ODR, pin);
}

void LED_Toggle(int pin) {
    (led ^= 1) ? LED_On(pin) : LED_Off(pin);
}

void LED_Display(int pin) {
    if (pin == 5) {
        // led on : 5
        LED_On(7);
        LED_On(6);
        LED_On(5);
    } else if (pin == 6) {
        // led on : 6
        LED_On(7);
        LED_Off(6);
        LED_Off(5);
    } else if (pin == 7) {
        // led on : 7
        LED_Off(7);
        LED_On(6);
        LED_Off(5);
    }
}