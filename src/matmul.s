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
    addi sp, sp, 
    sw s0, 0(sp) // outer_loop_counter
    sw s1, 4(sp) // inner_loop_counter
    sw s2, 8(sp) // m0 ptr 
    sw s3, 12(sp) // m0 height 
    sw s4, 16(sp) // m0 width 
    sw s5, 20(sp) // m1 ptr
    sw s6, 24(sp) // m1 height
    sw s7, 28(sp) // m1 width
    sw s8, 32(sp) // dest ptr
    mv s0, x0
    mv s1, x0
    mv s2, a0
    mv s3, a1
    mv s4, a2
    mv s5, a3 
    mv s6, a4
    mv s7, a5
    mv s8, a6
outer_loop_start:
    bge s0, a1, outer_loop_end
inner_loop_start:
    bge s1, a5, inner_loop_end
    mul t0, s0, s4
    slli t0, 2
    add a0, s2, t0
    mv t1, s1
    slli t1, 2
    add a1, s5, t1
    call dot
    



inner_loop_end:


outer_loop_end:


    # Epilogue


    ret
