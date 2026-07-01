#include <stdio.h>

#include "device_driver.h"

static void Sys_Init(int baud) {
    SCB->CPACR |= (0x3 << 10 * 2) | (0x3 << 11 * 2);
    Uart2_Init(baud);
    setvbuf(stdout, NULL, _IONBF, 0);
}

void Main(void) {
    volatile int i;

    Sys_Init(115200);
    printf("CMSIS Based Register Define\n");

    // LED Pin을 출력으로 설정
    GPIOA->MODER = (0x1 << 10) | (0x1 << 12) | (0x1 << 14);
    GPIOA->OTYPER = (0x0 << 5) | (0x0 << 6) | (0x0 << 7);

    for (;;) {
        // LED ON
        GPIOA->ODR = 0;
        GPIOA->ODR |= 0x1 << 7;
        GPIOA->ODR |= 0x0 << 6;
        GPIOA->ODR |= 0x0 << 5;
        for (i = 0; i < 0x40000; i++);

        // LED OFF
        GPIOA->ODR = 0;
        GPIOA->ODR |= 0x0 << 7;
        GPIOA->ODR |= 0x1 << 6;
        GPIOA->ODR |= 0x0 << 5;
        for (i = 0; i < 0x40000; i++);

        GPIOA->ODR = 0;
        GPIOA->ODR |= 0x0 << 7;
        GPIOA->ODR |= 0x0 << 6;
        GPIOA->ODR |= 0x1 << 5;
        for (i = 0; i < 0x40000; i++);
    }
}
