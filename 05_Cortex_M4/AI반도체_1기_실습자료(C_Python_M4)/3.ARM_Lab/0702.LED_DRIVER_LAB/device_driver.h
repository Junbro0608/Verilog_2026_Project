#include "macro.h"
#include "malloc.h"
#include "option.h"
#include "stm32f4xx.h"

// Uart.c

extern void Uart2_Init(int baud);
extern void Uart2_Send_Byte(char data);

// SysTick.c

extern void SysTick_Run(void);

// Led.c

extern void LED_Init();
extern void LED_On(int pin);
extern void LED_Off(int pin);
extern void LED_Toggle(int pin);
extern void LED_Display(int pin);
