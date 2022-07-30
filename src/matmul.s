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
    sw s0, 

outer_loop_start:




inner_loop_start:












inner_loop_end:




outer_loop_end:


    # Epilogue


    ret
