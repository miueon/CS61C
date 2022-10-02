#include "transpose.h"

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
  for (int x = 0; x < n; x++) {
    for (int y = 0; y < n; y++) {
      dst[y + x * n] = src[x + y * n];
    }
  }
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src) {
  // YOUR CODE HERE
  for (int y = 0; y < n; y += blocksize) {
    for (int x = 0; x < n; x += blocksize) {
      for (int i = 0; i < blocksize; i++) {
        for (int j =0; j < blocksize; j++) {
          int dstIndex = (y + j) + (x + i) * n;
          int srcIndex = (x + i) + (y + j) * n;
          if (x + i >= n || y + j >= n) {
            continue;
          }
          dst[dstIndex] = src[srcIndex];
        }
      }
    }
  }
}
