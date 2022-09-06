addi a0, x0, -10
addi a1, x0, 100
blt a0, x0, jmp
addi a0, a0, 10
jmp:
blt a0, a1, jmp2
addi a0, a0, 10
jmp2: