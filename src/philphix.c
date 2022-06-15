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
    base = stripFirst(base + keySize);
    int dataSize = getDataSize(base);
    char *data = getWord(base, dataSize);
    insertData(dictionary, key, data);
  }
}

/* Task 4 */
void processInput() {
  // -- TODO --
  // fprintf(stderr, "You need to implement processInput\n");
  
}
