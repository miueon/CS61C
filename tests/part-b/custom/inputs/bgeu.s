addi a0, x0, -1
addi a1, x0, 100
bgeu a0, a1, jmp
addi a0, a0, 10
jmp:
addi a0, x0, 10
bgeu a0, a1, jmp2
addi a0, a0, 10
jmp2: