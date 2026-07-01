
# ############################################################
# [12-1] 함수를 이용한 마트 셀프 계산기 설계
# ############################################################

# def mart_calc(x) :
#     global s
#     s += x

# s = 0

# mart_calc(10)
# mart_calc(30)
# print(s)

# ############################################################
# 여럿이 사용하는 마트 셀프 계산기 설계
# ############################################################

# def mart_calc(n, x) :
#     s[n] += x

# s = [0] * 5

# mart_calc(0, 10)
# mart_calc(1, 100)
# mart_calc(0, 30)
# mart_calc(1, 300)

# print(s[0], s[1])

# ############################################################
# [12-2] class로 만드는 마트 셀프 계산기
# ############################################################

# class Mart_Calc :
#     s = 0
#     def add(self, x) :
#         self.s += x

# usr1 = Mart_Calc()
# print(type(Mart_Calc))
# print(type(usr1))
# Mart_Calc.add(usr1, 50)
# usr1.add(10)
# print(usr1.s)
# print(Mart_Calc.s)

# ############################################################
# [12-3] class의 장점
# ############################################################

# class Mart_Calc :
#     s = 0
#     def add(self, x) :
#         self.s += x

# usr1 = Mart_Calc()
# usr2 = Mart_Calc()
# usr1.add(10)
# usr2.add(100)
# usr1.add(30)
# usr2.add(400)
# print(usr1.s)
# print(usr2.s)

# ############################################################
# [12-4] Class의 변수의 종류
# ############################################################

# s
# ############################################################/
# [12-5] Class의 Namespace 동작
# ############################################################

# class CLS :
#     a = 10
#     def f1(self, x) :
#         self.a += x
#         b = self.a

#     def f2(self, x) :
#         self.a += x
#         b = self.a

# c = CLS()
# c.f1(20)
# c.f2(200)
# print(c.a, CLS.a)

# ############################################################
# [12-6] 초기 값을 갖는 Instance 변수의 생성
# ############################################################

# class Mart_Calc :
#     def add(self, x) :
#         self.s += x
#         return self.s

# usr = Mart_Calc()
# usr.add(30)
# print(usr.s)

# ############################################################
# Class 변수를 이용한 Instance 변수 초기화
# ############################################################

# class Mart_Calc :
#     s = 0
#     def add(self, x) :
#         self.s += x

# usr = Mart_Calc()
# usr.add(30)
# print(usr.s)

# ############################################################
# [12-7] Instance 생성자와 초기화자 재정의
# ############################################################

# class Mart_Calc :
#     def __init__(self, x) :
#         print("init")
#         self.s = x
#     def add(self, x) :
#         self.s += x
#         return self.s

# usr = Mart_Calc(10)
# r = usr.add(30)
# print(r, usr.s)

# ############################################################
# [12-8] 마트 계산기 임대 수량을 관리하기
# ############################################################

# class Mart_Calc :
#     "Mart Self Calculator"
#     cnt, m = 0, "결제할 금액"
#     def __init__(self, x) :
#         self.s = x
#         Mart_Calc.cnt += 1
#     def add(self, x) :
#         self.s += x
#         print(f'{Mart_Calc.m} => {self.s}원')
#         return self.s

# print(Mart_Calc.__doc__)
# usr1 = Mart_Calc(10)
# usr2 = Mart_Calc(30)
# r1 = usr1.add(30)
# r2 = usr2.add(400)
# print(Mart_Calc.cnt, r1, usr1.s, r2, usr2.s)

# ############################################################
# [12-9] del 명령에 의한 Instance 소멸
# ############################################################

# class Mart_Calc :
#     cnt = 0
#     def __init__(self, x) :
#         self.s = x
#         Mart_Calc.cnt += 1
#     def add(self, x) :
#         self.s += x

# usr1 = Mart_Calc(10)
# usr2 = Mart_Calc(30)
# usr1.add(30)
# usr2.add(400)
# print(Mart_Calc.cnt, usr1.s, usr2.s)
# del(usr2)
# print(Mart_Calc.cnt)

# ############################################################
# [12-10] 마트 계산기 반납 시 임대 수량을 감소시키려면?
# ############################################################

# class Mart_Calc :
#     cnt = 0
#     def __init__(self, x) :
#         self.s = x
#         Mart_Calc.cnt += 1
#     def add(self, x) :
#         self.s += x

#     def __del__(self) :
#         Mart_Calc.cnt -= 1

# usr1 = Mart_Calc(10)
# usr2 = Mart_Calc(30)
# r1 = usr1.add(30)
# r2 = usr2.add(400)
# print(Mart_Calc.cnt, usr1.s, usr2.s)
# del(usr2)
# print(Mart_Calc.cnt)

# ############################################################
# [12-11] Special Method와 연산자 Overloading
# ############################################################

# a, b = 3, 5
# print(dir(int))
# r1 = a + b
# r2 = int.__add__(a, b)
# r3 = a.__add__(b)
# print(r1, r2, r3)
# print(dir(str))
# r4 = "Hi" + "Pyhhon"
# r5 = str.__add__("Hi", "Pyhhon")
# r6 = "Hi".__add__("Pyhhon")
# print(r4, r5, r6)

# ############################################################
# [12-12] 연산자와 Built-In 함수 Overloading
# ############################################################

# class CLS :
#     def __init__(self, x) :
#         self.s = x
#     def __add__(self, x) :
#         return self.s + x
#     def __gt__(self, x) :
#         return self.s > x.s
#     def __abs__(self) :
#         return -self.s
    
# usr1 = CLS(10)
# usr2 = CLS(-100)
# print(CLS.__add__(usr1, 30))
# print(usr1.__add__(30))
# print(usr1 + 30)
# print(usr1.__gt__(usr2))
# print(usr1 > usr2)
# print(usr2.__abs__())
# print(abs(usr2))

# ############################################################
# [12-13] Child Class 생성과 상속(Inheritance)
# ############################################################
# class Parent_CLS :
#     a = 10
#     def __init__(self) :
#         print("P_CLS")
#     def f(self, x) :
#         print("P_CLS : ", x)
# class Child_CLS(Parent_CLS) :
#     def __init__(self) :
#         print("C_CLS")

# c1 = Parent_CLS()
# c1.f(10)
# print(c1.a)
# c2 = Child_CLS()
# c2.f(20)
# print(c2.a)

# ############################################################
# [12-14] Child Class 생성과 상속(Inheritance)
# ############################################################

# class Mart_Calc :
#     def __init__(self, x) :
#         self.s = x
#         print("Mart_Calc")
#     def add(self, x) :
#         self.s += x
        
# class New_Calc(Mart_Calc):
#     def init(self, x) :
#         super().init(x)
#     def sub(self, x) :
#         self.s -= x

# usr1 = New_Calc(10)
# usr1.add(10)
# usr1.sub(40)
# print(usr1.s)

# ############################################################
# [12-15] Method Overriding
# ############################################################

# class Mart_Calc :
#     s = 10
#     def __init__(self, x) :
#         self.s = x
#     def add(self, x) :
#         self.s += x

# class New_Calc(Mart_Calc):
#     s = 20
#     def __init__(self, x) :
#         super().__init__(x)
#     def add(self, x) :
#         print('add')

# print(New_Calc.mro())
# usr1 = New_Calc(10)
# usr1.add(30)
# print(Mart_Calc.s, New_Calc.s)

# ############################################################
# [12-16] 여러 부모 Class로 부터 상속 받는 다중 상속
# ############################################################

# class Father :
#     def f1(self) :
#         print("Father f1")
#     def f2(self) :
#         print("Father f2")
# class Mother :
#     def f1(self) :
#         print("Mother f1")
#     def f3(self) :
#         print("Mother f3")
# class Son(Father, Mother) :
#     pass

# c = Son()
# print(Son.mro())
# c.f1()
# c.f2()
# c.f3()

# ############################################################
# [12-17] Class method, Static method
# ############################################################

class My_CLS :
    s = 0
    @classmethod
    def c_method(cls) :
        print("c_method :", cls.s)
    @staticmethod
    def s_method() :
        print("s_method :", My_CLS.s)

c = My_CLS()
My_CLS.c_method()
c.c_method()
My_CLS.s_method()
c.s_method()