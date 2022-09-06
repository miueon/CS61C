addi a0, x0, 10
addi a1, x0, 10
bne a0, x0, jmp
addi a0, a0, 10
jmp:
    sub a0, a0, a1
sub a0, a0, a1
bne a0, x0, jmp2
addi a0, a0, 10
jmp2:
