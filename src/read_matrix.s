.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    sw s3, 16(sp) 
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp) 
    sw s7, 32(sp)
    mv s0, a0 # ptr to filename
    mv s1, a1 # ptr to matrix rows
    mv s2, a2 # ptr to matrix columns
    mv s3, x0 # s3 will store the file descriptor
    mv s4, x0 # s4 will store the row size
    mv s5, x0 # s5 will store the column size
    mv s6, x0 # buffer ptr
    mv s7, x0 # read size
    # get the file decriptor
    mv a1, s0
    addi a2, x0, 0
    jal fopen
    addi t0, x0, -1
    beq a0, t0, fopen_failed
    mv s3, a0
    # read the rows and columns
    addi a0, x0, 8
    jal malloc # allocate the buffer to store the row column number
    beq a0, x0, malloc_failed
    mv s6, a0 # s6 now store the buffer ptr
    mv a1, s3
    mv a2, s6
    addi s7, x0, 8 # store the number of bytes to read for future comparison
    mv a3, s7 
    jal fread
    bne a0, s7, fread_failed
    lw s4, 0(s6)
    lw s5, 4(s6)
    sw s4, 0(s1)
    sw s5, 0(s2)
    mul s7, s4, s5
    slli s7, s7, 2 # stuck me one afternoon......
    mv a0, s7
    jal malloc # allocate the buffer to store the matrix
    beq a0, x0, malloc_failed
    mv s6, a0 # s6 now store the matrix buffer, which will be returned later
    mv a1, s3
    mv a2, s6
    mv a3, s7
    jal fread
    bne a0, s7, fread_failed
    # close file
    mv a1, s3
    jal fclose
    bne a0, x0, fclose_failed
    mv a0, s6
    j end
malloc_failed: 
    li a1, 88
    call exit2
fopen_failed:
    li a1, 89
    call exit2
fclose_failed:
    li a1, 90
    call exit2
fread_failed:
    li a1, 91
    call exit2
    # Epilogue
end: 
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    lw s3, 16(sp) 
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp) 
    lw s7, 32(sp)
    addi sp, sp, 36
    ret
