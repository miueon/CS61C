- Exercise 1:
    - Questions:
        *   How big is your cache block?
            - 
        *   How many consecutive accesses (taking into account the step size) fit within a single block?
        *   How much data fits in the WHOLE cache?
        *   How far apart in memory are blocks that map to the same set (and could create conflicts)?
        *   What is your cache's associativity?
        *   Where in the cache does a particular block map to?
        *   When considering why a specific access is a miss or hit: Have you accessed this piece of data before? If so, is it still in the cache or not?
    - S 1:  
        - option 0: only set to 0,  
        - 4 turns, 4 ac per turn, first 4 ac should fail, hit rate should be 0?  
    - S 2:  
        - option 1: read then set  
        - 1 turns, 32 ac per turn, |2 bit | 4 bit , every 8 word would hit the same set.  
        - task:  
            - 1. 2 mem accesses,  
            - 2. mhhh mh.... so the hit rate should be 75%  
            - 3. as the whole array can fit in the array without confliction. Thus the miss only happens in the first run.  
                - miss of first turn / (n * ac per-turn)  
    - S 3:  
        - op 0:  
        - array size: 32 W, step size 1, rep c 1  
        - cache: 2 level,  
            - l1: block size 8, number of blocks 8, direct mapped : 16 w  
            - l2: block size 8, number of blocks 16, direct mapped : 32 w  
        - 1 outer loop, 32 inner ac per tern,  
            - task:  
                - 1. L1 mhmh...8 | mh .. 50%  
                    - L2 no access happens during the first 16 accesses, 0%  
                - 2. 32 accesses for L1,half of them should missed  
                - 3.  16  
                - 4. rep count  
                - 5. increase num of blocks in L1 : hit rate for L1 still the same, no changes on L2  
                    6. increase block size of L1 : L1 hit rate up

        -  - scenarios 1:
            - step size, block size: Because [parameter A] in bytes is exactly equal to [parameter B] in bytes.
            - 0
            - alter the step size to 1 would increase the hit rate
        - scenarios 2:
            - 

- Ex 2:
    - 1. best: jki, kji
    - 2. worst: ikj, kij
    - The stride of each array in the inner loop matters.

- Ex 3:
    - block size: 20, n in [100, 1000, 2000, 5000, 10000]:
        - Q1: what point does the cache blocking faster than non-blocking?\
            - when the size is grater than 1000
        - Q2: why does cache blocking require the matrix to be a certain size
            - when the size is great or equal than 2000, the blocking version suddenly decrease it time consuming.
            - the reason may related to 
    - P2: changing block size: n: 10000, block size in [50, 100, 500, 1000, 5000]
        - Q: How does performance change as blocksize increases?
            - simple: the block line cannot fit in the set size
