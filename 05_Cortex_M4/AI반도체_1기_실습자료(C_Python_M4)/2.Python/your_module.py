#your_module.py

def mul(a, b):
    return a * b

def div(a, b):
    return a // b


for i in range(5):
    for j in range(9):
        if (4-i) =< j and j =< (4+i):
            print('*',end='')
        else:
            print(' ',end='')
    print()