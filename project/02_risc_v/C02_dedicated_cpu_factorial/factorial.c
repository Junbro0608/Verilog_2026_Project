#include <stdio.h>

int main(){

    int sum = 0, a = 0;
    
    while(a < 10){
        a = a + 1;
        sum = sum + a;
    }
    printf("%d",sum);

    return 0;
}