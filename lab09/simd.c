#include "simd.h"
#include <emmintrin.h>
#include <stdio.h>
#include <time.h>
#include <x86intrin.h>

long long int sum(int vals[NUM_ELEMS]) {
  clock_t start = clock();

  long long int sum = 0;
  for (unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
    for (unsigned int i = 0; i < NUM_ELEMS; i++) {
      if (vals[i] >= 128) {
        sum += vals[i];
      }
    }
  }
  clock_t end = clock();
  printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
  return sum;
}

long long int sum_unrolled(int vals[NUM_ELEMS]) {
  clock_t start = clock();
  long long int sum = 0;

  for (unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
    for (unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i += 4) {
      if (vals[i] >= 128)
        sum += vals[i];
      if (vals[i + 1] >= 128)
        sum += vals[i + 1];
      if (vals[i + 2] >= 128)
        sum += vals[i + 2];
      if (vals[i + 3] >= 128)
        sum += vals[i + 3];
    }

    // TAIL CASE, for when NUM_ELEMS isn't a multiple of 4
    // NUM_ELEMS / 4 * 4 is the largest multiple of 4 less than NUM_ELEMS
    // Order is important, since (NUM_ELEMS / 4) effectively rounds down first
    for (unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
      if (vals[i] >= 128) {
        sum += vals[i];
      }
    }
  }
  clock_t end = clock();
  printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
  return sum;
}

long long int sum_simd(int vals[NUM_ELEMS]) {
  clock_t start = clock();
  __m128i _127 = _mm_set1_epi32(
      127); // This is a vector with 127s in it... Why might you need this?
  long long int result = 0; // This is where you should put your final result!
  /* DO NOT MODIFY ANYTHING ABOVE THIS LINE (in this function) */
  for (unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
    __m128i sum_vec = _mm_setzero_si128();
    __m128i tmp;
    /* YOUR CODE GOES HERE */
    for (unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i += 4) {
      tmp = _mm_loadu_si128((__m128i *)(vals + i));
      __m128i mask = _mm_cmpgt_epi32(tmp, _127);
      tmp = _mm_and_si128(tmp, mask);
      sum_vec = _mm_add_epi32(sum_vec, tmp);
    }
    int tmp_arr[4];
    _mm_storeu_si128((__m128i *)tmp_arr, sum_vec);
    result += tmp_arr[0] + tmp_arr[1] + tmp_arr[2] + tmp_arr[3];

    for (unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
      if (vals[i] >= 128) {
        result += vals[i];
      }
    }
    /* Hint: you'll need a tail case. */
  }

  /* DO NOT MODIFY ANYTHING BELOW THIS LINE (in this function) */
  clock_t end = clock();
  printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
  return result;
}

long long int sum_simd_unrolled(int vals[NUM_ELEMS]) {
  clock_t start = clock();
  __m128i _127 = _mm_set1_epi32(127);
  long long int result = 0;
  /* DO NOT MODIFY ANYTHING ABOVE THIS LINE (in this function) */

  for (unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
    /* YOUR CODE GOES HERE */
    /* Copy your sum_simd() implementation here, and unroll it */
    __m128i sum_vecs[4] = {_mm_setzero_si128(), _mm_setzero_si128(), _mm_setzero_si128(), _mm_setzero_si128()};
    __m128i tmp[4];
    /* YOUR CODE GOES HERE */
    for (unsigned int i = 0; i < NUM_ELEMS / 16 * 16; i += 16) {
      tmp[0] = _mm_loadu_si128((__m128i *)(vals + i));
      __m128i mask = _mm_cmpgt_epi32(tmp[0], _127);
      tmp[0] = _mm_and_si128(tmp[0], mask);
      sum_vecs[0] = _mm_add_epi32(sum_vecs[0], tmp[0]);

      tmp[1] = _mm_loadu_si128((__m128i *)(vals + i + 4));
      mask = _mm_cmpgt_epi32(tmp[1], _127);
      tmp[1] = _mm_and_si128(tmp[1], mask);
      sum_vecs[1] = _mm_add_epi32(sum_vecs[1], tmp[1]);

      tmp[2] = _mm_loadu_si128((__m128i *)(vals + i + 8));
      mask = _mm_cmpgt_epi32(tmp[2], _127);
      tmp[2] = _mm_and_si128(tmp[2], mask);
      sum_vecs[2] = _mm_add_epi32(sum_vecs[2], tmp[2]);

      tmp[3] = _mm_loadu_si128((__m128i *)(vals + i + 12));
      mask = _mm_cmpgt_epi32(tmp[3], _127);
      tmp[3] = _mm_and_si128(tmp[3], mask);
      sum_vecs[3] = _mm_add_epi32(sum_vecs[3], tmp[3]);
    }
    int tmp_arr[16];
    _mm_storeu_si128((__m128i *)tmp_arr, sum_vecs[0]);
    _mm_storeu_si128((__m128i *) (tmp_arr + 4), sum_vecs[1]);
    _mm_storeu_si128((__m128i *) (tmp_arr + 8), sum_vecs[2]);
    _mm_storeu_si128((__m128i *) (tmp_arr + 12), sum_vecs[3]);
    for (int i = 0; i < 16; i++) {
        result += tmp_arr[i];
    }

    for (unsigned int i = NUM_ELEMS / 16 * 16; i < NUM_ELEMS; i++) {
      if (vals[i] >= 128) {
        result += vals[i];
      }
    }
    /* Hint: you'll need 1 or maybe 2 tail cases here. */
  }

  /* DO NOT MODIFY ANYTHING BELOW THIS LINE (in this function) */
  clock_t end = clock();
  printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
  return result;
}
