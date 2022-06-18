#include "ex1.h"
#include <string.h>

/* Returns the number of times LETTER appears in STR.
There are two different ways to iterate through a string.
1st way hint: strlen() may be useful
2nd way hint: all strings end in a null terminator */
int num_occurrences(char *str, char letter) {
  int strLength = strlen(str);
  int count = 0;
  for (size_t i = 0; i < strLength; i++) {
    if (str[i] == letter) {
      count += 1;
    }
  }

  return count;
}

/* Populates DNA_SEQ with the number of times each nucleotide appears.
Each sequence will end with a NULL terminator and will have up to 20
nucleotides. All letters will be upper case. */
void compute_nucleotide_occurrences(DNA_sequence *dna_seq) {
    char *sequence = dna_seq->sequence;
    dna_seq->A_count = num_occurrences(sequence, 'A');
    dna_seq->C_count = num_occurrences(sequence, 'C');
    dna_seq->G_count = num_occurrences(sequence, 'G');
    dna_seq->T_count = num_occurrences(sequence, 'T');
}
