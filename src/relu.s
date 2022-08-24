.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp) # a0
    sw s1, 4(sp) # a1
    sw s2, 8(sp) # counter
    add s0, a0, x0
    add s1, a1, x0
    add s2, x0, x0
    bgt s1, x0, loop_start
    li a1, 57
    call exit2 
loop_start:
    beq s2, s1, loop_end
    slli t0, s2, 2
    add t2, s0, t0
    lw t1, 0(t2)
    bgt t1, x0, loop_continue
    add t1, x0, x0
    sw t1, 0(t2)
loop_continue:
    addi s2, s2, 1
    j loop_start

loop_end:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12

    # Epilogue


	ret
