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
    LED_Init();
}

void Main(void) {
    Sys_Init(115200);
    printf("Test start\n");
    int uart_flag = 0;
    int led_flag = 0;
    int time_ledin = 0;
    int time_led = 0;
    int time_uart = 0;

    TIM2_Repeat_Interrupt_Enable(1, 100);
    Key_ISR_Enable(1);
    Uart2_RX_Interrupt_Enable(1);
    int d = 0;

    ADC1_IN6_Init();

    LEDout_Off();
    for (;;) {
        if (Uart_Data_In) {
            if (Uart_Data == 'a') {
                uart_flag = 1;
            }
            Uart_Data_In = 0;
        }
        if (Key_Pressed) {
            led_flag = 1;
            Key_Pressed = 0;
        }

        if (TIM2_Expired) {
            time_ledin++;
            if (time_ledin == 10) {
                (d ^= 1) ? LEDin_On() : LEDin_Off();
                time_ledin = 0;
            }
            TIM2_Expired = 0;

            if (uart_flag) {
                time_uart++;
                if (time_uart == 1) {
                    printf("h\t");
                } else if (time_uart == 11) {
                    printf("i\n");
                    uart_flag = 0;
                    time_uart = 0;
                }
            }

            if (led_flag) {
                time_led++;
                if (time_led < 6) {
                    LEDout_On();
                } else if (time_led < 11) {
                    LEDout_Off();
                } else if (time_led < 16) {
                    LEDout_On();
                } else if (time_led < 21) {
                    LEDout_Off();
                } else {
                    LEDout_Off();
                    led_flag = 0;
                    time_led = 0;
                }
            }
        }
    }
}
