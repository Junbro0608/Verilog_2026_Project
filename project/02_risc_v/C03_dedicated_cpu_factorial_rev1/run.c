#include <stdio.h>

int main(){

    int reg[4] = {0};
    //reg[0] : 0
    //reg[1] : a
    //reg[2] : sum
    //reg[3] : 상수 1

    while (reg[1] < 11)
    {
        reg[2] = reg[2] + reg[1];
        reg[1] = reg[1] + 1;
        printf("loop:%d\n",reg[2]);
    }
    printf("out:%d\n",reg[2]);

    return 0;
}