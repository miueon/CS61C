.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp) # counter
    sw s3, 12(sp) # max element value
    sw s4, 16(sp) # max element index
    mv s0, a0
    mv s1, a1
    mv s2, x0
    lw s3, 0(s0) 
    mv s4, x0
    bgt s1, x0, loop_start
    li a1, 57
    call exit2 
loop_start:
    beq s2, s1, loop_end
    slli t0, s2, 2
    add t1, s0, t0
    lw t2, 0(t1)
    blt t2, s3, loop_continue
    mv s3, t2
    mv s4, s2
loop_continue:
    addi s2, s2, 1
    j loop_start

loop_end:
    mv a0, s4
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp) # counter
    lw s3, 12(sp) # max element value
    lw s4, 16(sp) # max element index
    addi sp, sp, 20
    # Epilogue
    
    ret
