.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================
dot:

    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp) # counter for first array
    sw s6, 24(sp) # counter for sec array
    sw s7, 28(sp) # counter 

    mv s0, a0 # pointer to the first array
    mv s1, a1 # pointer to the sec array
    mv s2, a2 # number to use 
    mv s3, a3 # stride of first array
    mv s4, a4 # stride of sec array

    mv t0, x0 # dot result
    mv s5, x0
    mv s6, x0
    mv s7, x0

    ble s3, x0, stride_invalid
    ble s4, x0, stride_invalid
    bgt s2, x0, loop_start
    li a1, 57
    call exit2
stride_invalid:
    li a1, 58
    call exit2
loop_start:
    bge s7, s2, loop_end
    slli t1, s5, 2
    add t1, s0, t1
    lw t2, 0(t1)
    slli t3, s6, 2
    add t3, s1, t3 
    lw t4, 0(t3)
    mul t5, t2, t4
    add t0, t0, t5
    add s5, s5, s3 # add stride to first 
    add s6, s6, s4 # add stride to sec
    addi s7, s7, 1
    j loop_start
loop_end:


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp) # counter for first array
    lw s6, 24(sp) # counter for sec array
    lw s7, 28(sp)
    addi sp, sp, 32
    mv a0, t0
    ret
