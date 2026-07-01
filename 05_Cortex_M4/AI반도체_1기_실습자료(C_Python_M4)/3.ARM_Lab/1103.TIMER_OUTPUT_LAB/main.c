#if 0

#include <stdio.h>

#include "device_driver.h"

static void Sys_Init(int baud) {
    SCB->CPACR |= (0x3 << 10 * 2) | (0x3 << 11 * 2);
    Clock_Init();
    Uart2_Init(baud);
    setvbuf(stdout, NULL, _IONBF, 0);
    LED_Init();
}

#define BASE (500)  // msec

static void Buzzer_Beep(unsigned char tone, int duration) {
    const static unsigned short tone_value[] = {261, 277, 293, 311, 329, 349, 369, 391, 415, 440, 466, 493, 523, 554, 587, 622, 659, 698, 739, 783, 830, 880, 932, 987};

    TIM3_Out_Freq_Generation(tone_value[tone]);
    TIM2_Delay(duration);
    TIM3_Out_Stop();
}

void Main(void) {
    Sys_Init(115200);
    printf("Buzzer Test!!\n");

    int i;
    enum key { C1,
               C1_,
               D1,
               D1_,
               E1,
               F1,
               F1_,
               G1,
               G1_,
               A1,
               A1_,
               B1,
               C2,
               C2_,
               D2,
               D2_,
               E2,
               F2,
               F2_,
               G2,
               G2_,
               A2,
               A2_,
               B2 };
    enum note { N16 = BASE / 4,
                N8 = BASE / 2,
                N4 = BASE,
                N2 = BASE * 2,
                N1 = BASE * 4 };
    const int song1[][2] = {{G1, N4}, {G1, N4}, {E1, N8}, {F1, N8}, {G1, N4}, {A1, N4}, {A1, N4}, {G1, N2}, {G1, N4}, {C2, N4}, {E2, N4}, {D2, N8}, {C2, N8}, {D2, N2}};
    const char* note_name[] = {"C1", "C1#", "D1", "D1#", "E1", "F1", "F1#", "G1", "G1#", "A1", "A1#", "B1", "C2", "C2#", "D2", "D2#", "E2", "F2", "F2#", "G2", "G2#", "A2", "A2#", "B2"};

    TIM3_Out_Init();

    printf("%s ", note_name[C1]);
    Buzzer_Beep(C1, N4);
    printf("%s ", note_name[D1]);
    Buzzer_Beep(D1, N4);
    printf("%s ", note_name[E1]);
    Buzzer_Beep(E1, N4);
    printf("%s ", note_name[F1]);
    Buzzer_Beep(F1, N4);
    printf("%s ", note_name[G1]);
    Buzzer_Beep(G1, N4);
    printf("%s ", note_name[A1]);
    Buzzer_Beep(A1, N4);
    printf("%s ", note_name[B1]);
    Buzzer_Beep(B1, N4);
    printf("%s ", note_name[C2]);
    Buzzer_Beep(C2, N4);

    printf("\nSong Play\n");

    for (i = 0; i < (sizeof(song1) / sizeof(song1[0])); i++) {
        printf("%s ", note_name[song1[i][0]]);
        Buzzer_Beep(song1[i][0], song1[i][1]);
    }
}
#endif

#if 1

#include <stdio.h>

#include "device_driver.h"

#define BASE (300)  // msec (템포)

// 3옥타브(C3 ~ B3)까지 확장
enum key {
    C1,
    C1_,
    D1,
    D1_,
    E1,
    F1,
    F1_,
    G1,
    G1_,
    A1,
    A1_,
    B1,
    C2,
    C2_,
    D2,
    D2_,
    E2,
    F2,
    F2_,
    G2,
    G2_,
    A2,
    A2_,
    B2,
    C3,
    C3_,
    D3,
    D3_,
    E3,
    F3,
    F3_,
    G3,
    G3_,
    A3,
    A3_,
    B3,
    REST  // 쉼표 추가 (인덱스 36)
};

enum note {
    N16 = BASE / 4,
    N8 = BASE / 2,
    N4 = BASE,
    N2 = BASE * 2,
    N1 = BASE * 4
};

static void Sys_Init(int baud) {
    SCB->CPACR |= (0x3 << 10 * 2) | (0x3 << 11 * 2);
    Clock_Init();
    Uart2_Init(baud);
    setvbuf(stdout, NULL, _IONBF, 0);
    LED_Init();
}

static void Buzzer_Beep(unsigned char tone, int duration) {
    // 3옥타브 주파수까지 확장된 배열
    const static unsigned short tone_value[] = {
        261, 277, 293, 311, 329, 349, 369, 391, 415, 440, 466, 493,             // C1 ~ B1
        523, 554, 587, 622, 659, 698, 739, 783, 830, 880, 932, 987,             // C2 ~ B2
        1047, 1109, 1175, 1245, 1319, 1397, 1480, 1568, 1661, 1760, 1865, 1976  // C3 ~ B3
    };

    if (tone == REST) {
        TIM2_Delay(duration);
    } else {
        TIM3_Out_Freq_Generation(tone_value[tone]);
        TIM2_Delay(duration);
        TIM3_Out_Stop();

        // 음과 음 사이의 분리(스타카토 느낌)를 위한 짧은 딜레이
        TIM2_Delay(15);
    }
}

void Main(void) {
    Sys_Init(115200);
    printf("Mario Theme Test - Full Version!!\n");

    int i;

    // 마리오 지상 테마곡 멜로디 배열 (도입부 + 1절 + 2절)
    const int song1[][2] = {
        // --- 도입부 ---
        {E2, N8},
        {E2, N8},
        {REST, N8},
        {E2, N8},
        {REST, N8},
        {C2, N8},
        {E2, N4},
        {G2, N4},
        {REST, N4},
        {G1, N4},
        {REST, N4},

        // --- 1절 ---
        {C2, N4},
        {REST, N8},
        {G1, N8},
        {REST, N4},
        {E1, N4},
        {REST, N4},
        {A1, N4},
        {B1, N4},
        {A1_, N8},
        {A1, N4},
        {G1, N8},
        {E2, N8},
        {G2, N8},
        {A2, N4},
        {F2, N8},
        {G2, N8},
        {REST, N8},
        {E2, N4},
        {C2, N8},
        {D2, N8},
        {B1, N4},
        {REST, N4},

        // --- 1절 반복 ---
        {C2, N4},
        {REST, N8},
        {G1, N8},
        {REST, N4},
        {E1, N4},
        {REST, N4},
        {A1, N4},
        {B1, N4},
        {A1_, N8},
        {A1, N4},
        {G1, N8},
        {E2, N8},
        {G2, N8},
        {A2, N4},
        {F2, N8},
        {G2, N8},
        {REST, N8},
        {E2, N4},
        {C2, N8},
        {D2, N8},
        {B1, N4},
        {REST, N4},

        // --- 2절 (브릿지 파트: 빰 빰빰 빰 빰) ---
        {REST, N4},
        {G2, N8},
        {F2_, N8},
        {F2, N8},
        {D2_, N8},
        {E2, N4},
        {REST, N8},
        {G1, N8},
        {A1, N8},
        {C2, N4},
        {REST, N8},
        {A1, N8},
        {C2, N8},
        {D2, N4},

        {REST, N4},
        {G2, N8},
        {F2_, N8},
        {F2, N8},
        {D2_, N8},
        {E2, N4},
        {REST, N8},
        {C3, N4},
        {REST, N8},
        {C3, N8},
        {C3, N4},
        {REST, N4},  // 고음 파트

        {REST, N4},
        {G2, N8},
        {F2_, N8},
        {F2, N8},
        {D2_, N8},
        {E2, N4},
        {REST, N8},
        {G1, N8},
        {A1, N8},
        {C2, N4},
        {REST, N8},
        {A1, N8},
        {C2, N8},
        {D2, N4},

        // --- 2절 마무리 ---
        {REST, N4},
        {D2_, N4},
        {REST, N8},
        {D2, N4},
        {REST, N8},
        {C2, N2},
        {REST, N1}};

    const char* note_name[] = {
        "C1", "C1#", "D1", "D1#", "E1", "F1", "F1#", "G1", "G1#", "A1", "A1#", "B1",
        "C2", "C2#", "D2", "D2#", "E2", "F2", "F2#", "G2", "G2#", "A2", "A2#", "B2",
        "C3", "C3#", "D3", "D3#", "E3", "F3", "F3#", "G3", "G3#", "A3", "A3#", "B3",
        "REST"};

    TIM3_Out_Init();

    printf("\nMario Song Play Start!\n");

    for (i = 0; i < (sizeof(song1) / sizeof(song1[0])); i++) {
        printf("%s ", note_name[song1[i][0]]);
        Buzzer_Beep(song1[i][0], song1[i][1]);

        // 터미널 출력이 너무 길어지는 것을 방지하기 위해 10번째 음마다 줄바꿈
        if ((i + 1) % 10 == 0) {
            printf("\n");
        }
    }
    printf("\nSong End.\n");
}
#endif