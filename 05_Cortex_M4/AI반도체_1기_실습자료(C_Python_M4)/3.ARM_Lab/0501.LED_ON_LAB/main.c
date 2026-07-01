// 여기에 사용자 임의의 define을 작성하시오

#define GPIOA_MODER  (*(unsigned long*)0x40020000)
#define GPIOA_OTYPER (*(unsigned long*)0x40020004)
#define GPIOA_ODR    (*(unsigned long*)0x40020014)

void Main(void) {
    GPIOA_MODER = 0x4000;
    GPIOA_OTYPER = 0 << 5;

    GPIOA_ODR = 0;
    volatile int i;

    while (1) {
        GPIOA_ODR |= 0;
    }
}
