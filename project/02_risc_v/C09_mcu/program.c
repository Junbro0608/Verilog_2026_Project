#include <stdint.h>

//------------------<error messag>------------------------
#define SYS_ERR (-1)
#define SYS_OK (0)

//------------------<mem mepping>-------------------------
//BASE
#define APB_BRAM        (0x10000000)
#define APB_PERIPH_BASE (0x20000000)
#define APB_GPO         (APB_PERIPH_BASE + 0x0000U)
#define APB_GPI         (APB_PERIPH_BASE + 0x1000U)
#define APB_GPIO        (APB_PERIPH_BASE + 0x2000U)
#define APB_FND         (APB_PERIPH_BASE + 0x3000U)
#define APB_UART        (APB_PERIPH_BASE + 0x4000U)
//OFFSET
#define APB_GPO_CTRL    (APB_GPO  + 0x00U)
#define APB_GPO_ODATA   (APB_GPO  + 0x04U)
#define APB_GPI_CTRL    (APB_GPI  + 0x00U)
#define APB_GPI_IDATA   (APB_GPI  + 0x04U)
#define APB_GPIO_CTRL   (APB_GPIO + 0x00U)
#define APB_GPIO_ODATA  (APB_GPIO + 0x04U)
#define APB_GPIO_IDATA  (APB_GPIO + 0x08U)
#define APB_FND_CTRL    (APB_FND  + 0x00U)
#define APB_FND_ODATA   (APB_FND  + 0x04U)
#define APB_UART_CTRL   (APB_UART + 0x00U)
#define APB_UART_BAUD   (APB_UART + 0x04U)
#define APB_UART_STATUS (APB_UART + 0x08U)
#define APB_UART_TXDATA (APB_UART + 0x0CU)
#define APB_UART_RXDATA (APB_UART + 0x10U)

//------------------<GPIO_TYPEDEF>-------------------------
#define __IO volatile

typedef struct {
    __IO uint32_t CTRL;
    __IO uint32_t ODATA;
    __IO uint32_t IDATA;
} GPIO_TYPEDEF;

#define GPIO0 ((GPIO_TYPEDEF *) APB_GPIO)

//------------------<function>------------------------
void GPIO_init(GPIO_TYPEDEF *GPIOx, unsigned int control);
void led_write(GPIO_TYPEDEF *GPIOx, unsigned int wdata);
unsigned int sw_read(GPIO_TYPEDEF *GPIOx);
void delay_ms(int delay);
int sys_init(void);


//------------------<main>------------------------
void main(){
    int time = 0;
    int ret = SYS_ERR;
    unsigned int gpio0;
    GPIO_TYPEDEF gpio_a;
    unsigned int blink_flag = 0;

    ret = sys_init();
    time = 1000;
    while(1){
        if(!time){
            //1sec
            time = 1000;
            
            //led blink
            if(!blink_flag){
                blink_flag = 1;
                led_write(GPIO0, gpio0);
            }
            else{
                blink_flag = 0;
                led_write(GPIO0, ~gpio0);
            }

            gpio0 = sw_read(GPIO0);
        }
        delay_ms(1);
        time --;
    }


    return;
}

//------------------<function>------------------------
void GPIO_init(GPIO_TYPEDEF *GPIOx, unsigned int control){
    GPIOx->CTRL = control;
    return;
} //GPIO_init


void led_write(GPIO_TYPEDEF *GPIOx, unsigned int wdata){
    
    GPIOx->ODATA = wdata;
    return;
} //led_write

unsigned int sw_read(GPIO_TYPEDEF *GPIOx){
    return GPIOx->IDATA;
} //sw_read

int sys_init(void){
    int i = 0;
    //RAM 
    *(volatile unsigned int *) APB_BRAM = 0x0;
    i = *(unsigned int *) APB_BRAM;
    if (i == 0x0){
        //error message output
        //UART_PRINT("SYS_ERR")
        return SYS_ERR;
    }
    //GPO
    *(volatile unsigned int *) APB_GPO_CTRL = 0x0; //GPO ctrl data
    *(volatile unsigned int *) APB_GPO_ODATA = 0x0; //GPO output data
    //GPI
    *(volatile unsigned int *) APB_GPI_CTRL = 0x0; //GPI ctrl data
    i = *(volatile unsigned int *) APB_GPI_IDATA;   //GPI input data
    //GPIO
    *(volatile unsigned int *) APB_GPIO_CTRL = 0x0; //GPIO ctrl data
    *(volatile unsigned int *) APB_GPIO_ODATA = 0x0; //GPIO input data
    //FND
    *(volatile unsigned int *) APB_FND_CTRL = 0x0; //FND ctrl data
    *(volatile unsigned int *) APB_FND_ODATA = 0x0; //FND input data
    //UART
    *(volatile unsigned int *) APB_UART_CTRL = 0x0; //UART ctrl data
    *(volatile unsigned int *) APB_UART_BAUD = 0x0; //UART input data
    *(volatile unsigned int *) APB_UART_TXDATA = 0x0; //UART input data
    
    GPIO_init(GPIO0,0x0000ff00); //GPIO[15:8] : LED ouput, GPIO[7:0] : 
    return SYS_OK;
} //sys_init


void delay_ms(int delay){
    delay = delay * 100000/3;
    while(delay){
        delay--;
    }
    return;
} //delay_ms