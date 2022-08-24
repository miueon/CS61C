.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 72
    # - If malloc fails, this function terminates the program with exit code 88
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    addi sp, sp, -80
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s5, 16(sp)
    sw s6, 20(sp)
    sw s7, 24(sp)
    sw s8, 28(sp)
    sw s9, 32(sp)
    sw ra, 36(sp)
    sw s4, 40(sp)
    mv s0, a0

    # check the number of command line arguments is exactly 5
    li t0, 5
    bne s0, t0, num_of_args_wrong

    mv s1, a1 # char** 
    mv s2, a2 # set 0 print result
    mv s3, x0 # filepath
    addi t0, sp, 44
    mv s4, t0 # stack array to store the matrix ptr with cols and rows 
    # 0(s4)-> ptr of m0 
    # 4(s4) -> * m0 rows 
    # 8(s4) -> * m0 cols
    # ... m1, input 
    mv s5, x0 # h ptr
    mv s6, x0 # h size
    mv s7, x0 # o ptr
    mv s8, x0 # o size
    mv s9, x0 # argmax result

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    lw s3, 4(s1)
    mv a0, s3
    addi t0, s4, 4 # m0 rows
    mv a1, t0
    addi t0, s4, 8 # m0 cols
    mv a2, t0
    jal read_matrix
    sw a0, 0(s4) # that 0 is needed

    # Load pretrained m1
    lw s3, 8(s1)
    mv a0, s3
    addi t0, s4, 16 # m1 rows
    mv a1, t0
    addi t0, s4, 20 # m1 cols
    mv a2, t0
    jal read_matrix
    sw a0, 12(s4)

    # Load input matrix
    lw s3, 12(s1)
    mv a0, s3
    addi t0, s4, 28 # input rows
    mv a1, t0
    addi t0, s4, 32 # input cols
    mv a2, t0
    jal read_matrix
    sw a0, 24(s4)

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # claim the buffer to store h
    lw t0, 4(s4) # m0 rows
    lw t1, 32(s4) # input cols
    mul s6, t0, t1
    mv a0, s6
    slli a0, a0, 2
    jal malloc
    beq a0, x0, malloc_failed
    mv s5, a0

    # 1. mat_mul
    mv a0, s4
    lw a1, 4(s4)
    lw a2, 8(s4)
    mv a3, s4
    addi a3, a3, 24
    lw a4, 28(s4)
    lw a5, 32(s4)
    mv a6, s5
    jal matmul

    # 2. relu
    mv a0, s5
    mv a1, s6
    jal relu

    # claim the buffer to store o
    lw t0, 16(s4) # m1 rows
    lw t1, 32(s4) # input cols
    mul s8, t0, t1
    mv a0, s8
    slli a0, a0, 2
    jal malloc
    beq a0, x0, malloc_failed
    mv s7, a0

    # 3. comput o
    mv a0, s4
    addi a0, a0, 12
    lw a1, 16(s4)
    lw a2, 20(s4)
    mv a3, s5
    lw a4, 4(s4)
    lw a5, 32(s4)
    mv a6, s7
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    mv a1, s7
    lw a2, 16(s4)
    lw a3, 32(s4)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s7
    mv a1, s8
    jal argmax
    mv s9, a0
    bne s2, x0, free_
    # Print classification
    mv a1, s9
    jal print_int

    # Print newline afterwards for clarity
    li a1, '\n'
    jal print_char
    j free_
malloc_failed:
    li a1 88
    call exit2
num_of_args_wrong:
    li a1 72
    call exit2
free_:
    mv a0, s5 # free h
    jal free
    mv a0, s7 # free o
    jal free
    lw a0, 0(s4) # free m0
    jal free
    lw a0, 12(s4) # free m1
    jal free 
    lw a0, 24(s4) # free input
    jal free

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s5, 16(sp)
    lw s6, 20(sp)
    lw s7, 24(sp)
    lw s8, 28(sp)
    lw s9, 32(sp)
    lw ra, 36(sp)
    lw s4, 40(sp)
    addi sp, sp, 80

    ret
