.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 92
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    mv s0, a0 # ptr to filename
    mv s1, a1 # matrix addr
    mv s2, a2 # matrix rows
    mv s3, a3 # matrix columns
    mv s4, x0 # s4 stores the fd 
    mv s5, x0 # s5 stores the buffer ptr
    mv s6, x0 # s6 stores the buffer size
    # open file with write permission
    mv a1, s0
    addi a2, x0, 1
    jal fopen
    addi t0, x0, -1
    beq a0, t0, fopen_failed
    mv s4, a0
    # allocate the mem to store row and column num
    addi a0, x0, 8
    jal malloc
    beq a0, x0, malloc_failed
    mv s5, a0
    sw s2, 0(s5)
    sw s3, 4(s5)
    addi s6, x0, 2
    mv a1, s4
    mv a2, s5
    mv a3, s6
    addi a4, x0, 4 # 4 bytes for each element
    jal fwrite
    bne a0, s6, fwrite_failed
    mv a1, s4
    mv a2, s1
    mul s6, s2, s3
    mv a3, s6
    addi a4, x0, 4
    jal fwrite
    bne a0, s6, fwrite_failed
    # close file 
    mv a1, s4
    jal fclose
    bne a0, x0, fclose_failed
    j end

malloc_failed:
    li a1, 88
    call exit2
fopen_failed:
    li a1, 89
    call exit2
fwrite_failed:
    li a1, 92
    call exit2
fclose_failed:
    li a1, 90
    call exit2
end:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32
    # Epilogue
    ret
