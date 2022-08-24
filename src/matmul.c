int dot(int *a0, int *a1, int a2, int a3, int a4);
void mat_mul(int *A, int A_w, int A_h, int *B, int B_w, int B_h, int *C) {
  for (int i = 0; i < A_h; i++) {
    for (int j = 0; j < B_w; j++) {
        int t0 = i * A_w;
        int* a = A + t0;
        int* b = B + j;
        int t3 =i*B_w + j;
        C[t3] = dot(a, b, A_w, B_w, A_w);
    }
  }
}