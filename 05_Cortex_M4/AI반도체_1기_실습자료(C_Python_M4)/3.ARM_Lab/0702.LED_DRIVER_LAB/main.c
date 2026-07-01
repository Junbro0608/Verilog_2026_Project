#include <stdio.h>

#include "device_driver.h"

static void Sys_Init(int baud) {
    SCB->CPACR |= (0x3 << 10 * 2) | (0x3 << 11 * 2);
    Uart2_Init(baud);
    setvbuf(stdout, NULL, _IONBF, 0);
}

void Main(void) {
    Sys_Init(115200);
    printf("LED Driver\n");

    volatile int i;
    int led = 0;

    LED_Init();

    for (;;) {
        // (led ^= 1) ? LED_Off() : LED_On();
        for (int j = 5; j < 8; j++) {
            LED_Display(j);
            for (i = 0; i < 0x20000; i++);
        }
    }
}
