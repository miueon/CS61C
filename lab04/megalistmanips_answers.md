1. `:70`
    
    `add t1, s0, x0` --> `lw t1, 0(s0)`: s0 stores the address to the node,
    
    while we need the address to the array. 
    
    The address to the array stores at the first element of the node regarding to the node structure
    
    So we need to load it first. This is similar to the expression `node -> addr` in c
2. `:74`

    `add t1, t1, t0` --> 
    ```asm
    slli t3, t0, 2 
    add t1, t1, t3
    ```
    we intended to make `t1` point to the element. The error comes by simply add scalar to the base ptr

3. `:78`
    ```asm
    addi sp, sp, -12        # mis.3 caller should save the temporary reg.
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    jalr s1             # call the function on that value.
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    addi sp, sp, 12
    ```
    caller should save their responding registers. But for the sake of simplicity, I just save 3 of them.

4. `:93`

    `la a0, 8(s0)` --> `lw a0, 8(a0)` 

    `la` is a pseudo instruction which only used for load address of a label to `PC`


5. `:94`

    `lw a1, 0(s1)` --> `add a1, s1, x0`  put the address of the function back into a1 to prepare for the recursion

    But `s1` already the address to the function, so it shouldn't be load by `lw` again

6. `:103`

    missed `ret`. without this instruction, processor just go on and on until it hit a `ret` or something