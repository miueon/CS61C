addi a0, x0, 10
addi a1, x0, 10
bge a0, a1, jmp
addi a0, a0, 10
jmp:
    sub a0, a0, a1
sub a0, a0, a1
addi a1, a1, 10
bge a0, a1, jmp2
addi a0, a0, 10
jmp2: