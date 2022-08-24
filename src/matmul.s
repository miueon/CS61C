.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================
matmul:

    # Error checks
    ble a1, x0, height_width_invalid
    ble a2, x0, height_width_invalid
    ble a4, x0, height_width_invalid
    ble a5, x0, height_width_invalid
    bne a2, a4, widthA_heightB_uneuqal
    j prologue
height_width_invalid:
    li a1, 59
    call exit2
widthA_heightB_uneuqal:
    li a1, 59
    call exit2
    # Prologue
prologue:
    addi sp, sp, -44
    sw s0, 0(sp) # outer_loop_counter
    sw s1, 4(sp) # inner_loop_counter
    sw s2, 8(sp) # m0 ptr 
    sw s3, 12(sp) # m0 height 
    sw s4, 16(sp) # m0 width 
    sw s5, 20(sp) # m1 ptr
    sw s6, 24(sp) # m1 height
    sw s7, 28(sp) # m1 width
    sw s8, 32(sp) # dest ptr
    sw s9, 36(sp) # dest index
    sw ra, 40(sp) # ret addr.
    mv s0, x0
    mv s1, x0
    mv s2, a0
    mv s3, a1
    mv s4, a2
    mv s5, a3 
    mv s6, a4
    mv s7, a5
    mv s8, a6
    mv s9, x0
outer_loop_start:
    bge s0, s3, outer_loop_end
inner_loop_start:
    bge s1, s7, inner_loop_end
    mul t0, s0, s4
    slli t0, t0, 2 # index for m0
    add a0, s2, t0 # start ptr of m0 to dot func
    mv t1, s1 
    slli t1, t1, 2 # index for m1
    add a1, s5, t1 # start ptr of m1 
    add a2, x0, s4 # passing the argument to dot
    addi a3, x0, 1 # stride for m0 is 1
    mv a4, s7 # !!! the stride should be the width of current matrix
    mul s9, s0, s7 # dest index initiallize, cauze sx is the callee saved ptr. So it can save a lot of time 
    add s9, s9, s1
    slli s9, s9, 2
    add s9, s9, s8 # compute the addr of dest
    ebreak # check the dot argument is correct
    jal ra, dot
    sw a0, 0(s9) # save dot result
    addi s1, s1, 1
    j inner_loop_start
inner_loop_end:
    addi s0, s0, 1
    mv s1, x0
    j outer_loop_start
outer_loop_end:
    lw s0, 0(sp) # outer_loop_counter
    lw s1, 4(sp) # inner_loop_counter
    lw s2, 8(sp) # m0 ptr 
    lw s3, 12(sp) # m0 height 
    lw s4, 16(sp) # m0 width 
    lw s5, 20(sp) # m1 ptr
    lw s6, 24(sp) # m1 height
    lw s7, 28(sp) # m1 width
    lw s8, 32(sp) # dest ptr
    lw s9, 36(sp) # dest index
    lw ra, 40(sp) # ret addr.
    addi sp, sp, 44
    # Epilogue
    ret
