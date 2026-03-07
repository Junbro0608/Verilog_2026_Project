#include <stdio.h>


// 0 + 1 + 2 + 3 + ... + 9+ 10 = 55
int main(){

    int sum = 0, a = 0;
    
    while(a < 11){
        sum = sum + a;
        a = a + 1;
    }
    printf("out = %d",sum);

    return 0;
}

