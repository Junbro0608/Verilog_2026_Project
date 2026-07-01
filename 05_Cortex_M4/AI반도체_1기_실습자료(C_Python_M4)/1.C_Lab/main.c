#define _CRT_SECURE_NO_WARNINGS

/***********************************************************/
// [1-1] Hello C World! 인쇄하기
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    printf("Hello C World!");

    return 0;
}
#endif

/***********************************************************/
// [1-2] 두 줄의 인쇄
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	printf("Hello");
	printf("C World!");

	return 0;
}
#endif

/***********************************************************/
// [1-3] 특수 기능 문자
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	printf("Hello\n");
	printf("Tab\tTab\n");
	printf("Character\0 Ghost\n");

	return 0;
}
#endif

/***********************************************************/
// [1-4] 특수 문자를 일반 문자로
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    printf("\"Welcome!!\"\n");
    printf("Back Slash\\\n");

    return 0;
}
#endif

/***********************************************************/
// [1-5] 상수와 포맷지시어
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    printf("%d\n", 100);
    printf("%f is real number\n", 3.14);
    printf("%c == %c\n", 'A', 65);
    printf("Hello %s\n", "C Wolrd!");

    return 0;
}
#endif

/***********************************************************/
// [1-6] 변수 선언, 정의, 초기화
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int x;
	int y = 20;

	x = 10;
	printf("%d %d\n", x, y);

	x = 30;
	y = x + 10;
	printf("%d %d\n", x, y);

	return 0;
}
#endif

/***********************************************************/
// [1-7] 문자는 숫자다
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    char x = 'C';
    char y = '2';

    printf("%d %c %x\n", x, x, x);
    printf("%c %c %c\n", 'C', 67, 0x43);
    printf("%c %c\n", x + 1, x + ('a' - 'A'));
    printf("%d %d\n", x - 'A', y - '0');

    return 0;
}
#endif

/***********************************************************/
// [2-1] scanf 함수
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    int i;
    float f;

    printf("Input:");
    scanf("%d", &i);
    scanf("%f", &f);

    printf("%d %f\n", i, f);

    return 0;
}
#endif

/***********************************************************/
// [2-2-1] 여러개의 정수 받기 1
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    int a, b, c;

    scanf("%d%d%d", &a, &b, &c);
    printf("%d %d %d\n", a, b, c);

    return 0;
}
#endif

/***********************************************************/
// [2-2-2] 여러개의 정수 받기 2
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    int a, b, c;

    scanf("%d %d %d", &a, &b, &c);
    printf("%d %d %d\n", a, b, c);

    return 0;
}
#endif

/***********************************************************/
// [2-3-1] 문자 입력 받기 1
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    char a, b;

    scanf("%c%c", &a, &b);
    printf("%c %c\n", a, b);

    return 0;
}
#endif

/***********************************************************/
// [2-3-2] 문자 입력 받기 2
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    char a, b;

    scanf("%c %c", &a, &b);
    printf("%c %c\n", a, b);

    return 0;
}
#endif

/***********************************************************/
// [2-4-1] 문자 두 줄로 입력 받기 - 1
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    char a, b;

    scanf("%c", &a);
    scanf("%c", &b);
    printf("%c %c\n", a, b);

    return 0;
}
#endif

/***********************************************************/
// [2-4-2] 문자 두 줄로 입력 받기 - 2
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	char a, b, c;

	scanf(" %c", &a);
	scanf(" %c %c", &b, &c);
	printf("%c %c %c\n", a, b, c);

	return 0;
}
#endif

/***********************************************************/
// [2-5] 문자열을 입력받는 scanf
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	char a[101];
	char b[101];
		
	scanf(" %s     %s", a, b);
	printf("%s, %s\n", a, b);

	return 0;
}
#endif

/***********************************************************/
// [2-6] 공백이 포함된 문자열 입력 받기
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    char a[101];
    char b[101];

    gets(a);
    gets(b);
    printf("%s, %s\n", a, b);

    return 0;
}
#endif

/***********************************************************/
// [3-1] 사칙연산
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    int a = 10, b = 4;

    printf("a + b = %d\n", a + b);
    printf("a - b = %d\n", a - b);
    printf("a * b = %d\n", a * b);
    printf("a / b = %f\n", 10.0 / 4.0);

    printf("a / b = %d\n", a / b);
    printf("a %% b = %d\n", a % b);

    return 0;
}
#endif

/***********************************************************/
// [3-2] 기본 연산자 우선순위
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    int a = 10, b = 20;
    int c0, c1;

    c0 = a + b / 2;
    c1 = (a + b) / 2;

    printf("%d %d\n", c0, c1);

    return 0;
}
#endif

/***********************************************************/
// [3-3] /, % 연산자의 활용
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    int oil, n, r;

    scanf("%d", &oil);

    n = oil / 8;
    r = oil % 8;

    printf("생산=%d병, 잔량=%d리터\n", n, r);

    return 0;
}
#endif

/***********************************************************/
// [3-4] 복합대입 연산자
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    int a = 20, b = 4;

    a += 3;
    printf("%d\n", a);

    a -= b;
    printf("%d\n", a);

    return 0;
}
#endif

/***********************************************************/
// [3-5] ++, -- 증가, 감소 연산자
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    int a = 10, b = 0;

    a++;
    printf("%d\n", a);

    ++a;
    printf("%d\n", a);

    b = ++a + b;
    printf("%d, %d\n", a, b);

    b = a++ + b;
    printf("%d, %d\n", a, b);

    return 0;
}
#endif

/***********************************************************/
// [3-6] cast 연산자
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    int i;
    float f;

    i = 3.5 + 5.9;
    f = 5 / 3;

    printf("%d, %f\n", i, f);

    i = (int)3.5 + (int)f;
    f = (float)5 / (float)2;

    printf("%d, %f\n", i, f);

    return 0;
}
#endif

/***********************************************************/
// [3-7] sizeof, &(address of) 연산자
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    int a = 10;

    printf("%d\n", sizeof(a));
    printf("%d\n", sizeof(float));
    printf("%d\n", sizeof(10.4));
    printf("%d\n", sizeof("Hello"));
    printf("0x%p\n", &a);

    return 0;
}
#endif

/***********************************************************/
// [4-1] Parameter와 Return 모두 없는 함수
/***********************************************************/

#if 0
#include <stdio.h>

void welcome(void) {
    printf("Hello!\n");
}

int main(void) {
    welcome();

    return 0;
}
#endif

/***********************************************************/
// [4-2] 함수의 parameter
/***********************************************************/

#if 0
#include <stdio.h>

void print_weight(int w)
{
	printf("Weight = %d\n", w);
}

int main(void)
{
	print_weight(50);

	return 0;
}
#endif

/***********************************************************/
// [4-3] 함수의 return
/***********************************************************/

#if 0
#include <stdio.h>

int Get_My_Weight(void)
{1
	int weight = 70; 
	return weight;
}

int main(void)
{
	int x = 50, y;

	y = Get_My_Weight() + 10;
	
	printf("%dkg\n", y);

	return 0;
}
#endif

/***********************************************************/
// [4-4] 함수의 parameter와 return
/***********************************************************/

#if 0
#include <stdio.h>

int add(int a, int b)
{
	int c;
	
	c = a + b;
	return c;	
}

int main(void)
{
	int a = 3, b = 5;

	printf("%d\n", add(a, b));

	return 0;
}
#endif

/***********************************************************/
// [4-5] 함수의 위치
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	print_weight(50);

	return 0;
}

void print_weight(int w)
{
	printf("Weight = %d\n", w);
}
#endif

/***********************************************************/
// [4-6] 함수의 선언
/***********************************************************/

#if 0
#include <stdio.h>

void print_weight(int);

int main(void)
{
	print_weight(50);

	return 0;
}

void print_weight(int w)
{
	printf("Weight = %d\n", w);
}
#endif

/***********************************************************/
// [4-7] 변수의 유효 범위(scope)
/***********************************************************/

#if 0
#include <stdio.h>

int a = 1, b = 2;

void func(void)
{
	int c = 400;
	printf("%d %d %d\n", a,b,c);
}

int main(void)
{
	int b = 20, c = 30;
	printf("%d %d %d\n", a,b,c);

	func();

	return 0;
}
#endif

/***********************************************************/
// [4-8] #define과 Macro
/***********************************************************/

#if 0
#include <stdio.h>

#define MAX        10
#define PRT_INT(x) printf("%d\n", x)

int main(void)
{
	int a = MAX;
	PRT_INT(a);

	return 0;
}
#endif

/***********************************************************/
// [4-9] Macro의 주의사항
/***********************************************************/

#if 0
#include <stdio.h>

#define SQR(x) x* x

int main(void)
{
	int a = 5;

	printf("%d\n", SQR(a));
	printf("%d\n", SQR(a + 2));

	return 0;
}
#endif

/***********************************************************/
// [5-1] if 문
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	if(1)	printf("True\n");
	if(0)	printf("False\n");
	if(-1)	printf("True\n");
	if(0)	printf("False\n");

	return 0;
}
#endif

/***********************************************************/
// [5-2] 복합문
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	if (1)
		printf("True1\n");
		printf("True2\n");
	if (0)	
		printf("False1\n");
		printf("False2\n");

	if (3.5)
	{
		printf("True1\n");
		printf("True2\n");
	}

	if (0.0)
	{
		printf("False1\n");
		printf("False2\n");
	}
	
	printf("End\n");

	return 0;
}
#endif

/***********************************************************/
// [5-3] if ~ else 문
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	if(1)	printf("True\n");
	else	printf("False\n"); 

	if(0)
	{
		printf("1\n");
		printf("2\n");
	}
	else
	{
		printf("3\n");
		printf("4\n");
	}

	return 0;
}
#endif

/***********************************************************/
// [5-4] 비교 연산
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a = 10;
	int b = 0;

	if (b == 0) printf("1\n");
	if (b != a) printf("2\n");
	if (b >= 0) printf("3\n");
	if (a < b) printf("4\n");
	
	printf("%d, %d\n", a == 10, a > b);

	return 0;
}
#endif

/***********************************************************/
// [5-5] if ~ else 주의사항
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a = 12;

	if (a % 2 == 0) printf("2\n");
	if (a % 3 == 0) printf("3\n");
	if (a % 5 == 0) printf("5\n");
	else  printf("X\n");

	return 0;
}
#endif

/***********************************************************/
// [5-6] 한가지 조건만 충족해야 하는 경우
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a = 12;

	if (a % 2 == 0) printf("2\n");
	else if (a % 3 == 0) printf("3\n");
	else if (a % 5 == 0) printf("5\n");
	else  printf("X\n");

	return 0;
}
#endif

/***********************************************************/
// [5-7-1] 홀짝을 맞춰라 - 1
/***********************************************************/

#if 0

#include <stdio.h>

int Check_Odd_Even(int num)
{
	if (num % 2 == 0) return 1;
	else return 0;
}

int main(void)
{
	int num;

	scanf("%d", &num);
	printf("%d\n", Check_Odd_Even(num));

	return 0;
}
#endif

/***********************************************************/
// [5-7-2] 홀짝을 맞춰라 - 2
/***********************************************************/

#if 0

#include <stdio.h>

int Check_Odd_Even(int num)
{
	return num % 2 == 0;
}

int main(void)
{
	int num;

	scanf("%d", &num);
	printf("%d\n", Check_Odd_Even(num));

	return 0;
}
#endif

/***********************************************************/
// [5-8] 논리 연산자
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a = 10;
	char b = '@';

	printf("%d\n", (a == 10) && (b == '@'));
	printf("%d\n", (a == 10) && (b != '@'));
	printf("%d\n", (a == 10) || (b != '@'));
	printf("%d\n", (a < 10) || (b != '@'));
	printf("%d\n", !(a < 10));
	printf("%d\n", !(a == 10));

	return 0;
}
#endif

/***********************************************************/
// [5-9] 2 또는 3의 배수 판단하기
/***********************************************************/

#if 0
#include <stdio.h>

void check23(int num)
{
	if ((num % 2 == 0) || (num % 3 == 0)) printf("YES\n");
	else printf("NO\n");
}

int main(void)
{
	int num;
	scanf("%d", &num);
	check23(num);

	return 0;
}
#endif

/***********************************************************/
// [5-10] switch 문
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a = 2;

	switch (a)
	{
		case 1: printf("1\n");
		case 2: printf("2\n");
		case 3: printf("3\n");
		default: printf("4\n");
	}

	return 0;
}
#endif

/***********************************************************/
// [5-11] switch문의 break
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a = 2;

	switch (a)
	{
		case 1: printf("1\n"); break;
		case 2: printf("2\n"); break;
		case 3: printf("3\n"); break;
		default: printf("4\n");
	}

	return 0;
}
#endif

/***********************************************************/
// [6-1] 0부터 9까지 인쇄하기
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i;

	for (i = 0; i < 10; i++)
	{
		printf("%d ", i);
	}

	printf("\n");
	return 0;
}
#endif

/***********************************************************/
// [6-2-1] 알아두면 편리한 for 루프 구문 1
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i, d;

	scanf("%d", &d);

	for (i = 0; i < d; i++)
	{
		printf("*");
	}

	return 0;
}
#endif

/***********************************************************/
// [6-2-2] 알아두면 편리한 for 루프 구문 2
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i, X, N;

	scanf("%d %d", &X, &N);

	for (i = X; i < (N + X); i++)
	{
		printf("%d, *\n", i);
	}

	return 0;
}
#endif

/***********************************************************/
// [6-2-3] 알아두면 편리한 for 루프 구문 3
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i, N;

	scanf("%d", &N);

	for (i = 0; i <= N; i++)
	{
		printf("%d ", i);
	}

	return 0;
}
#endif

/***********************************************************/
// [6-2-4] 알아두면 편리한 for 루프 구문 4
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i, X, N;

	scanf("%d %d", &X, &N);

	for (i = X; i <= N; i++)
	{
		printf("%d ", i);
	}

	return 0;
}
#endif

/***********************************************************/
// [6-3] 1 부터 입력 받은 수 까지 짝수의 합 구하기 함수
/***********************************************************/

#if 0
#include <stdio.h>

int sum(int n)
{
	int i, s = 0;

	for (i = 1; i <= n; i++)
	{
		if (i % 2 == 0) s += i;
	}

	return s;
}

int main(void)
{
	int num;

	scanf("%d", &num);
	printf("%d\n", sum(num));

	return 0;
}
#endif

/***********************************************************/
// [6-4] 사각별 찍기
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i, j;

	for (i = 0; i < 5; i++)
	{
		for (j = 0; j < 5; j++)
		{
			printf("*");
		}
		printf("\n");
	}

	return 0;
}
#endif

/***********************************************************/
// [6-5] 사각별 찍기 함수화
/***********************************************************/

#if 0
#include <stdio.h>

void prt_star(int n)
{
	int i;

	for (i = 0; i < 5; i++)
	{
		printf("*");
	}
	printf("\n");
}

int main(void)
{
	int i;

	for (i = 0; i < 5; i++)
	{
		prt_star(5);
	}

	return 0;
}
#endif

/***********************************************************/
// [6-6] 숫자 삼각형
/***********************************************************/

#if 0
#include <stdio.h>

void prt_num(int n)
{
	int i;

	for (i = 1; i <= n; i++)
	{
		printf("%d", i);
	}
	printf("\n");
}

int main(void)
{
	int i;

	for (i = 0; i < 5; i++)
	{
		prt_num(i + 1);
	}

	return 0;
}
#endif

/***********************************************************/
// [6-7] for와 break 문
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i;

	for (i = 0; i < 10; i++)
	{
		if (i == 7) break;
		printf("%d\n", i);
	}

	return 0;
}
#endif

/***********************************************************/
// [6-8] 다중 for 루프의 탈출
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i, j;

	for (i = 0; i < 10; i++)
	{
		for (j = 0; j < 10; j++)
		{
			if (j == 7) break;
			printf("%d\n", j);
		}

		printf("j = %d Out\n", j);
	}

	printf("i = %d Out\n", i);

	return 0;
}
#endif

/***********************************************************/
// [6-9-1] 다중 for 루프의 탈출 해결책 - 1
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i, j, x = 0;

	for (i = 0; i < 10; i++)
	{
		for (j = 0; j < 10; j++)
		{
			if (j == 7)
			{
				x = 1;
				break;
			}
			printf("%d\n", j);
		}

		if (x == 1) break;
	}

	return 0;
}
#endif

/***********************************************************/
// [6-9-2] 다중 for 루프의 탈출 해결책 - 2
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i, j;

	for (i = 0; i < 10; i++)
	{
		for (j = 0; j < 10; j++)
		{
			if (j == 7) break;
			printf("%d\n", j);
		}

		if (j != 10) break;
	}

	return 0;
}
#endif

/***********************************************************/
// [6-9-3] 다중 for 루프의 탈출 해결책 - 3
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i, j;

	for (i = 0; i < 10; i++)
	{
		for (j = 0; j < 10; j++)
		{
			if (j == 7) goto TAG1;
			printf("%d\n", j);
		}
	}

TAG1 :
	return 0;
}
#endif

/***********************************************************/
// [6-10] 특정 조건이 될 때까지 반복하기
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int n;

	for(;;)
	{
		scanf("%d", &n);
		if (n == 9) break;
		printf("%d\n", n);
	}

	return 0;
}
#endif

/***********************************************************/
// [7-1] 배열과 인덱싱
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a[4] = { 10, 20, 30, 40 };
	char b[] = { 'a', 'b', 'c', 'd' };
	char c[] = "ABCD";
	
	a[1] = -20;

	printf("%d %d %d\n", a[0], a[1], a[3]);
	printf("%c %c %c\n", b[0], b[1], b[3]);
	printf("%c %c %c\n", c[0], c[1], c[3]);
	printf("%d %d\n", sizeof(b), sizeof(c));

	return 0;
}
#endif

/***********************************************************/
// [7-2] 정수 10개의 합 구하기
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i, s = 0;
	int a[10] = { 10, 3, 30, 40, -3, 9, 20, 5, -10, 2};

	for (i = 0; i < 10; i++)
	{
		s += a[i];
	}

	printf("%d\n", s);

	return 0;
}
#endif

/***********************************************************/
// [7-3] 정수 10개 받아서 배열에 저장하기
/***********************************************************/

#if 0
#include <stdio.h>

#define ARR_MAX 10

int main(void)
{
	int i, s = 0;
	int a[ARR_MAX];

	for (i = 0; i < ARR_MAX; i++)
	{
		scanf("%d", &a[i]);
	}

	for (i = 0; i < ARR_MAX; i++)
	{
		s += a[i];
	}

	printf("%d\n", s);

	return 0;
}
#endif

/***********************************************************/
// [7-4] 이차원 배열
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a[3][4] = { {1,2,3,4}, {5,6,7,8}, {9,10,11,12} };

	a[1][2] = -7;
	printf("%d, %d, %d\n", a[0][0], a[1][2], a[2][3]);

	return 0;
}
#endif

/***********************************************************/
// [7-5] 이차원 배열의 구조 이해
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i, j;
	int	sum[3] = { 0,0,0 };
	int a[3][4] = { {1,2,3,4}, {5,6,7,8}, {9,10,11,12} };

	for (i = 0; i < 3; i++)
	{
		for (j = 0; j < 4; j++)
		{
			sum[i] += a[i][j];
		}
	}

	printf("%d, %d, %d\n", sum[0], sum[1], sum[2]);

	return 0;
}
#endif

/***********************************************************/
// [7-6] 문자열을 저장하는 배열
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int i;	
	char s[][7] = { "Hello", "C", "World!" };

	s[0][1] = 'a';

	for (i = 0; i < 3; i++)
	{
		printf("%c : %s\n", s[i][0], s[i]);
	}

	return 0;
}
#endif

/***********************************************************/
// [7-7] 다양한 타입을 집합으로 관리하는 구조체
/***********************************************************/

#if 0
#include <stdio.h>

struct st
{
	int a;
	char b;
};

int main(void)
{
	struct st x;

	x.a = 200;
	x.b = 'B';
	printf("%d, %c\n", x.a, x.b);

	return 0;
}
#endif

/***********************************************************/
// [7-8] 다양한 구조체 멤버와 액세스
/***********************************************************/

#if 0
#include <stdio.h>

struct st1
{
	int a;
	char b;
};

struct st2
{
	int c;
	int d[4];
	struct st1 e;
};

int main(void)
{
	struct st2 x = { 1, {10,20,30,40}, {100, 'A'} };

	printf("%d %d %d\n", x.c, x.d[0], x.d[1]);
	printf("%d %c\n", x.e.a, x.e.b);

	return 0;
}
#endif

/***********************************************************/
// [7-9] 구조체 복사
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	struct st
	{
		int a;
		char b;
	}x, y, z = { 100, 'A' };

	x.a = z.a;
	x.b = z.b;

	y = z;

	printf("%d, %d\n", x.a, x.b);
	printf("%d, %d\n", y.a, y.b);

	return 0;
}
#endif

/***********************************************************/
// [7-10] 구조체를 저장하는 배열
/***********************************************************/

#if 0
#include <stdio.h>

struct st
{
	int a;
	char b;
};

int main(void)
{
	int i;
	struct st x[4] = { {10, 'A'}, {20, 'B'}, {30, 'C'}, {40, 'D'} };

	for (i = 0; i < 4; i++)
	{
		x[i].a = i;
		printf("%d, %c\n", x[i].a, x[i].b);
	}

	return 0;
}
#endif

/***********************************************************/
// [7-11] typedef
/***********************************************************/

#if 0
#include <stdio.h>

typedef signed int SI;
typedef unsigned char BYTE;

int main(void)
{
	SI a;
	BYTE x[4] = { 'A','B','C','D' };
	
	a = (SI)'A';
	printf("%d, %c, %c\n", a, x[0], x[1]);

	return 0;
}
#endif

/***********************************************************/
// [7-12] 구조체의 typedef
/***********************************************************/

#if 0
#include <stdio.h>

typedef struct st
{
	int a;
	char b;
}ST1;

int main(void)
{
	ST1 x = { 100, 'A' };

	printf("%d, %c\n", x.a, x.b);

	return 0;
}
#endif

/***********************************************************/
// [8-1]  다양한 진법을 위한 format 지시자
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	printf("10진수 => %d\n", 100);
	printf("16진수 => %x와 %X\n", 0xF0, 0xF0);	
	printf("8진수 => %o\n", 034);	

	printf("%d, %x, %o\n", 100, 100, 100);
	printf("%d, %x, %o\n", 0x64, 0x64, 0x64);
	printf("%d, %x, %o\n", 0144, 0144, 0144);
	
	printf("%d, %#x, %#o\n", 100, 100, 100);
	printf("%d, 0x%x, 0%o\n", 100, 100, 100);

	return 0;	
}
#endif

/***********************************************************/
// [8-2-1] 알아두면 편리한 while 구문 1
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a = 0;

	while (a < 10)
	{
		printf("%d\n", a);
		a++;
	}

	return 0;		
}
#endif

/***********************************************************/
// [8-2-2] 알아두면 편리한 while 구문 2
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a = 0;

	while (!(a == 13))
	{
		printf("%d\n", a);
		a++;
	}

	return 0;	
}
#endif

/***********************************************************/
// [8-3] do ~ while의 일반적인 형식
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a = 0;

	do a++; while (a < 10);

	a = 10;

	do
		a++;
	while (a < 10);

	a = 10;

	do
	{
		a++;
	} while (a < 10);

	printf("a=%d\n", a);
	
	return 0;
}
#endif

/***********************************************************/
// [8-4] 배열의 메모리 분석
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a[4];
	
	a[0] = 0;
	a[1] = 10;
	a[2] = 20;
	a[3] = 30;

	printf("%p %p %p %p %p\n", &a, &a[0], &a[1], &a[2], &a[3]);
	printf("%d %d %d %d\n", a[0], a[1], a[2], a[3]);

	return 0;	
}
#endif

/***********************************************************/
// [8-5] 이차원 배열 메모리 구조와 요소수
/***********************************************************/

#if 0
#include <stdio.h>

#define ARR_SIZE(x) (sizeof((x)) / sizeof((x)[0]))

int main(void)
{
	int a[3][4] = { {1,2,3,4}, {5,6,7,8}, {9,10,11,12} };

	printf("%d, %d\n", ARR_SIZE(a), ARR_SIZE(a[0]));
	printf("%p, %p, %p, %p\n", &a,&a[0],&a[0][0],&a[1]);
	
	return 0;	
}
#endif

/***********************************************************/
// [8-6] 합이 가장 큰 행과 열 찾기
/***********************************************************/

#if 0
#include <stdio.h>

int N;
int a[10+10][10+10];
int max_row, max_col;

int main(void)
{
      int i, j;

      scanf("%d", &N);

      for(i=0; i<N; i++)
      {
            for(j=0; j<N; j++)
            {
                  scanf("%d", &a[i][j]);
            }
      }

      // 여기서부터 작성


      printf("%d %d", max_row, max_col);
      
      return 0;
}
#endif

/***********************************************************/
// [8-7] 이차원 배열 Transpose
/***********************************************************/

#if 0
#include <stdio.h>

int a[4][4] = { {1,2,3,4}, {5,6,7,8}, {9,10,11,12}, {13, 14, 15, 16} };
int b[4][4];

void transpose1(void)
{
	// 코드 구현
}

int main(void)
{
	int i, j;

	for (i = 0; i < 4; i++)
	{
		for (j = 0; j < 4; j++)
		{
			printf("%d ", a[i][j]);
		}
		printf("\n");
	}

	transpose1();

	for (i = 0; i < 4; i++)
	{
		for (j = 0; j < 4; j++)
		{
			printf("%d ", b[i][j]);
		}
		printf("\n");
	}
	
	return 0;			
}
#endif

/***********************************************************/
// [8-8] 다른 모양의 이차원 배열 Transpose
/***********************************************************/

#if 0
#include <stdio.h>

int a[3][4] = { {1,2,3,4}, {5,6,7,8}, {9,10,11,12} };
int b[4][3];

void transpose2(void)
{
	// 코드 구현
}

int main(void)
{
	int i, j;

	for (i = 0; i < 3; i++)
	{
		for (j = 0; j < 4; j++)
		{
			printf("%d ", a[i][j]);
		}
		printf("\n");
	}

	transpose2();

	for (i = 0; i < 4; i++)
	{
		for (j = 0; j < 3; j++)
		{
			printf("%d ", b[i][j]);
		}
		printf("\n");
	}
	
	return 0;			
}
#endif

/***********************************************************/
// [8-9] 구조체 멤버의 타입은 멤버 자신의 타입
/***********************************************************/

#if 0
#include <stdio.h>

struct st
{
	int a;
	char b[4];
}x = { 100, "ABC" };

int main(void)
{
	char a[4] = "ABC";

	a = "LEW";
	x.b = "LEW";
	
	return 0;		
}
#endif

/***********************************************************/
// [8-10] 문자열을 복사 또는 메모리를 복사
/***********************************************************/

#if 0
#include <stdio.h>
#include <string.h>

struct st
{
	int a;
	char b[4];
}x = { 100, "ABC" };

int main(void)
{
	char a[4] = "ABC";

	memcpy(a, "LEW", sizeof("LEW"));
	strcpy(x.b, "LEW");

	printf("%s, %s\n", a, x.b);
	
	return 0;	
}
#endif

/***********************************************************/
// [8-11] 공용체
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    union uni {
        int a;
        unsigned char b;
    } x = {0x12345678};

    printf("0x%x, 0x%x\n", x.a, x.b);
    printf("0x%.8x, 0x%.8x\n", &x.a, &x.b);
    printf("%d, %d\n", sizeof(x.a), sizeof(x.b));
    printf("0x%.8x, %d\n", &x, sizeof(x));

    x.b = 0xEF;
    printf("0x%x, 0x%x\n", x.a, x.b);
    printf("%s, %s\n", x.a, x.b);

    return 0;
}
#endif

/***********************************************************/
// [8-12] 공용체 활용 예 : 엔디안 모드 변경
/***********************************************************/

#if 0
#include <stdio.h>

union uni
{
	int a;
	char b[4];
};

int Change_Endian(int data)
{
	char tmp;
	union uni x;
	x.a = data;

	// 코드 작성

	return x.a;
}

int main(void)
{
	int a = 0x12345678;

	printf("0x%.8x => 0x%.8x\n", a, Change_Endian(a));
	printf("%s, %s\n", a, x.b);
	
	return 0;		
}
#endif

/***********************************************************/
// [9-1] 포인터
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a = 10;
	int * p = &a;

	printf("0x%p 0x%p %d %d\n", &a, p, a, *p);
	printf("%d %d\n", sizeof(p), sizeof(*p));
	
	return 0;		
}
#endif

/***********************************************************/
// [9-2] 다양한 타입을 가리키는 포인터
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	char a = 'A';
	char *p = &a;

	double f = 3.14;
	double *q = &f;

	printf("%d, %c\n", sizeof(*p), *p);
	printf("%d, %f\n", sizeof(*q), *q);
	printf("0x%p, 0x%p\n", p, p + 1);
	printf("0x%p, 0x%p\n", q, q + 1);
	
	return 0;		
}
#endif

/***********************************************************/
// [9-3] Call by Value, Call by Address
/***********************************************************/

#if 0
#include <stdio.h>

void f1(int b)
{
	b = 100;
	printf("%d\n", b);
}

void f2(int *p)
{
	*p = 100;
	printf("%d\n", *p);
}

int main(void)
{
	int a = 10;

	f1(a);
	printf("%d\n", a);

	f2(&a);
	printf("%d\n", a);
	
	return 0;		
}
#endif

/***********************************************************/
// [9-4] %s 포맷 지시자와 문자열
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	char a[] = "Hello";
	char *p = "Hello";

	printf("%s\n", "Hello");
	printf("%s, %s, %s\n", &a[0], a, p);
	printf("%s, %s, %s\n", "Hello" + 1, a + 1, p + 1);
	
	return 0;		
}
#endif

/***********************************************************/
// [9-5] 문자열의 정체
/***********************************************************/

#if 0
#include <stdio.h>

char* func(char* q) {
    printf("%s, %c, %c\n", q, q[0], q[1]);
    printf("0x%p, 0x%p, %c, %c\n", q, q + 1, *q, *(q + 1));

    return q + 2;
}

int main(void) {
    char* p = "Hello";

    printf("%s, 0x%p, 0x%p\n", "Hello", "Hello", "Hello" + 1);
    printf("%c, %c, %c, %c\n", "Hello"[0], "Hello"[1], *"Hello", *("Hello" + 1));
    printf("%s\n", func("Hello"));

    return 0;
}
#endif

/***********************************************************/
// [9-6-1] *p++, *++p의 동작
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    int cnt = 0;
    char* p = "Embedded";

    while (*p) {
        if (*p++ == 'd') cnt++;
    }

    printf("%d\n", cnt);

    return 0;
}
#endif

/***********************************************************/
// [9-6-2] [] 연산자를 사용한 코드
/***********************************************************/
#if 0
#include <stdio.h>

int main(void)
{
	int cnt = 0, i = 0;
	char *p = "Embedded";

	while (p[i])
	{
		if (p[i++] == 'd') cnt++;
	}

	printf("%d\n", cnt);
	
	return 0;		
}
#endif

/***********************************************************/
// [9-7] 문자열 복사
/***********************************************************/

#if 0
#include <stdio.h>

void str_copy1(char * d, char * s)
{
	int i;

	for (i = 0; ; i++)
	{
		d[i] = s[i];
		if (d[i] == '\0') return;
	}
}

void str_copy2(char * d, char * s)
{
	while (*d++ = *s++);
}

int main(void)
{
	char a[5], b[5];
	char c[5] = "ABCD";

	str_copy1(a, c);
	str_copy2(b, c);
	printf("%s %s %s\n", a, b, c);
	
	return 0;		
}
#endif

/***********************************************************/
// [9-8] 10개 정수를 갖는 배열의 합을 구하는 함수
/***********************************************************/

#if 0
#include <stdio.h>

int sum1(int a[10])
{
	int i, s = 0;

	for (i = 0; i < 10; i++)
	{
		s += a[i];
	}

	return s;
}

int sum2(int a[10])
{
	int i, s = 0;

	for (i = 0; i < sizeof(a) / sizeof(a[0]); i++)
	{
		s += a[i];
	}

	return s;
}

int sum3(int *a)
{
	int i, s = 0;

	for (i = 0; i < sizeof(a) / sizeof(a[0]); i++)
	{
		s += a[i];
	}

	return s;
}

int main(void)
{
	int a[10] = { 1,2,3,4,5,6,7,8,9,10 };
	int r;

	r = sum1(a);
	printf("SUM1 = %d\n", r);

	r = sum2(a);
	printf("SUM2 = %d\n", r);
	
	r = sum3(a);
	printf("SUM3 = %d\n", r);	
	
	return 0;		
}
#endif

/***********************************************************/
// [9-9] 배열 활용식을 이용한 요소 액세스
/***********************************************************/

#if 0
#include <stdio.h>

int main(void) {
    int a[4] = {1, 2, 3, 4};

    printf("%d\n", a[0]);
    printf("%d\n", a[3]);
    printf("%d\n", a[4]);
    printf("%d\n", a[-1]);

    printf("%d\n", (a + 1)[2]);
    printf("%d\n", a[3]);

    return 0;
}
#endif

/***********************************************************/
// [9-10] 포인터의 [] 연산자 사용
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a[4] = { 1,2,3,4 };
	int *p = a;

	printf("%d, %d\n", a[0], *p);
	printf("%d, %d\n", a[1], *(p + 1));
	
	return 0;		
}
#endif

/***********************************************************/
// [9-11] 함수의 배열 Parameter
/***********************************************************/

#if 0
#include <stdio.h>

void func()
{
	printf("a[3] = %d\n", );
}

int main(void)
{
	int a[4] = { 1,2,3,4 };
	func(a);
	
	return 0;		
}
#endif

/***********************************************************/
// [9-12] 함수의 배열 Return
/***********************************************************/

#if 0
#include <stdio.h>

func(void)
{
	static int a[4] = { 1,2,3,4 };
	return a;
}

int main(void)
{
	printf("a[3] = %d\n", func();
	
	return 0;		
}
#endif

/***********************************************************/
// [9-13] 대치법의 이해
/***********************************************************/

#if 0
#include <stdio.h>

int x[4] = {1, 2, 3, 4};

int* f1(void) {
    return x;
}

void f2(int* p) {
    printf("%d, %d, %d, %d\n", x[2], *(x + 2), p[0], *p);
}

int main(void) {
    int* p;
    int* a[4] = {x + 3, x + 2, x + 1, x};

    p = x;

    printf("%d, %d\n", x[2], p[2]);
    printf("%d, %d, %d, %d\n", x[2], *(x + 2), a[3][2], *a[1]);
    printf("%d, %d, %d, %d\n", x[2], *(x + 2), f1()[2], *(f1() + 2));
    f2(x + 2);

    return 0;
}
#endif

/***********************************************************/
// [9-14] 포인터가 가리키는 대상
/***********************************************************/

#if 0
#include <stdio.h>

int main(void)
{
	int a = 100;
	int b[4] = {10, 20, 30, 40};
	int c[2][3] = {{11,22,33},{44,55,66}};

	int *p = &a;
	int (*q)[4] = &b;
	int (*r)[2][3] = &c;

	printf("%d, %d, %d\n",  *p,  (*q)[3], (*r)[1][2]);
	printf("%d, %d, %d\n", p[0], q[0][3], r[0][1][2]);
	
	return 0;		
}
#endif

/***********************************************************/
// [9-15] 구조체 포인터
/***********************************************************/

#if 0
#include <stdio.h>

struct st
{
	int a;
	char b;
}x = { 10, 'A' };

int main(void)
{
	struct st * p = &x;

	// 코드 작성

	printf("%c\n", x.b);
	
	return 0;		
}
#endif

/***********************************************************/
// [9-16] -> 연산자
/***********************************************************/

#if 0
#include <stdio.h>

struct st
{
	int a;
	char b;
}x = { 10, 'A' };

int main(void)
{
	struct st * p = &x;

	(*p).b = 'L';
	printf("%c\n", x.b);

	p->b = 'K';
	printf("%c\n", x.b);

	p[0].b = 'L';
	printf("%c\n", x.b);
	
	return 0;		
}
#endif

/***********************************************************/
// [9-17] 구조체의 함수 전달
/***********************************************************/

#if 0
#include <stdio.h>

struct st
{
	int num;
	char name[10];
	int score;
};

void cheat(struct st math)
{
	math.score = 100;
}

int main(void)
{
	struct st math = { 1, "KIM", 10 };

	cheat(math);
	printf("%s: %d점\n", math.name, math.score);
	
	return 0;		
}
#endif

/***********************************************************/
// [9-18] 구조체 포인터를 이용한 코드 수정
/***********************************************************/

#if 0
#include <stdio.h>

struct st
{
	int num;
	char name[10];
	int score;
};

void cheat(struct st * math)
{
	// 코드 작성
}

int main(void)
{
	struct st math = { 1, "KIM", 10 };

	cheat(&math);
	printf("%s: %d점\n", math.name, math.score);
	
	return 0;		
}
#endif
