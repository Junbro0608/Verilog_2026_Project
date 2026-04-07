# component 계열만으로 UVM 설계하기
1. 간결한 구조로 phase단계 이해하기
2. monitor와 driver만을 활용하여 UVM구성하기
## 시나리오
 counter를 1~16까지 카운팅하도록 시간을 보내며 posedeg clk의 1ns뒤에 monitor하여 같은지 비교

![uvm 구조](./README_image/uvm.png)

## report
![log1](./README_image/log1.png)
![log2](./README_image/log2.png)


# sequence 다용도성