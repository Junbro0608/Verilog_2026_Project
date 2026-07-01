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

extern void LED_Init(void);
extern void LED_On(void);
extern void LED_Off(void);
extern void LED_Toggle(int pin);

// Clock.c

extern void Clock_Init(void);
