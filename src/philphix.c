/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philphix.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

#include <time.h>
/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in
 * the grading process.
 */
#ifndef _PHILPHIX_UNITTEST
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 1;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(0x61C, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}
#endif /* _PHILPHIX_UNITTEST */

int allowedKeyChar(char s) {
  if (s >= 'A' && s <= 'Z') {
    return 1;
  } else if (s >= 'a' && s <= 'z') {
    return 1;
  } else if (s >= '0' && s <= '9') {
    return 1;
  }
  return 0;
}

char *stripFirst(char *s) {
  char *base = s;
  while (base[0] == '\0' || base[0] == ' ' || base[0] == '\t') {
    base += 1;
  }
  return base;
}

int isEmpty(const char *s) {
  while (*s) {
    if (!isspace(*s)) {
      return 0;
    }
    s++;
  }
  return 1;
}

int getKeySize(char *s) {
  int size = 0;
  while (allowedKeyChar(s[size])) {
    size++;
  }
  return size;
}

char *getWord(char *base, int size) {
  char *word = malloc(size * sizeof(char));
  strncpy(word, base, size);
  return word;
}

int getDataSize(char *s) {
  int size = 0;

  while (s[size] != ' ' && s[size] != '\t' && s[size] != '\0' &&
         s[size] != '\n') {
    size++;
  }
  return size;
}
/* Task 3 */
void readDictionary(char *dictName) {
  // -- TODO --
  // fprintf(stderr, "You need to implement readDictionary\n");
  FILE *dictFile = fopen(dictName, "r");
  if (dictFile == NULL) {
    fprintf(stderr, "file name=%s, not exits", dictName);
    exit(61);
  }
  char *line = NULL;
  size_t len = 0;
  size_t read;

  while ((read = getline(&line, &len, dictFile)) != -1) {
    if (isEmpty(line)) {
      continue;
    }

    char *base = stripFirst(line);
    int keySize = getKeySize(base);
    char *key = getWord(base, keySize);
    key[keySize] = '\0';

    base = stripFirst(base + keySize);
    int dataSize = getDataSize(base);
    char *data = getWord(base, dataSize);
    data[dataSize] = '\0';
    insertData(dictionary, key, data);

  }
}

void clearBuffer(char *buffer) { buffer[0] = '\0'; }
int isBufferEmpty(char *buffer) { return buffer[0] == '\0'; }
char *variation2(char *buffer) {
  int bufferSize = strlen(buffer);
  char *v2 = malloc((bufferSize + 1) * sizeof(char));
  v2[0] = buffer[0];
  v2[bufferSize] = '\0';
  for (size_t i = 1; buffer[i] != '\0'; i++) {
    if (buffer[i] >= 'A' && buffer[i] <= 'Z') {
      v2[i] = tolower(buffer[i]);
      continue;
    }
    v2[i] = buffer[i];
  }

  return v2;
}

char *variation3(char *buffer) {
  char *v3 = variation2(buffer);
  if (v3[0] >= 'A' && v3[0] <= 'Z') {
    v3[0] += 32;
  }
  return v3;
}
/* Task 4 */
void processInput() {
  // -- TODO --
  // fprintf(stderr, "You need to implement processInput\n");
  int input;
  char ch;
  int bufferSize = 1000;
  char *buffer = malloc(bufferSize * sizeof(char));
  buffer[0] = '\0';
  int bufferIndex = 0;
  char *output = NULL;
  int outputted = 0;
  while ((input = getchar()) != EOF || !isBufferEmpty(buffer)) {
    ch = input;
    if (!allowedKeyChar(ch)) {
      if (!isBufferEmpty(buffer)) {
        buffer[bufferIndex] = '\0';
        // variation1
        output = findData(dictionary, buffer);
        outputted = 0;
        if (output != NULL) {
          printf("%s", output);
          outputted = 1;
        }

        // variation2
        char *v2 = variation2(buffer);
        output = findData(dictionary, v2);
        if (output != NULL && !outputted) {
          printf("%s", output);
          outputted = 1;
          free(v2);
        }

        char *v3 = variation3(buffer);
        output = findData(dictionary, v3);
        if (output != NULL && !outputted) {
          printf("%s", output);
          outputted = 1;
          free(v3);
        }
        if (!outputted) {
          printf("%s", buffer);
        }
      }
      if (input != EOF) {
        printf("%c", ch);
      }

      clearBuffer(buffer);
      bufferIndex = 0;
      continue;
    }

    buffer[bufferIndex] = ch;
    bufferIndex += 1;

    if (bufferIndex == bufferSize) {
      bufferSize <<= 1;
      char *newBuffer = malloc(bufferSize * sizeof(char));
      strncpy(newBuffer, buffer, bufferIndex);
      free(buffer);
      buffer = newBuffer;
    }
  }
}
