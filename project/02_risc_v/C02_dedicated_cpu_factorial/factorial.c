#include <stdio.h>

int main(){

    int sum = 0, a = 0;
    
    for(int i=0;i<10;i++){
        a = a + 1;
        sum = sum + a;
    }
    printf("%d",sum);

    return 0;
}