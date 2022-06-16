#include "hashtable.h"

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This creates a new hash table of the specified size and with
 * the given hash function and comparison function.
 */
HashTable *createHashTable(int size, unsigned int (*hashFunction)(void *),
                           int (*equalFunction)(void *, void *)) {
  int i = 0;
  HashTable *newTable = malloc(sizeof(HashTable));
  if (NULL == newTable) {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }
  newTable->size = size;
  newTable->buckets = malloc(sizeof(struct HashBucketEntry *) * size);
  if (NULL == newTable->buckets) {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }
  for (i = 0; i < size; i++) {
    newTable->buckets[i] = NULL;
  }
  newTable->hashFunction = hashFunction;
  newTable->equalFunction = equalFunction;
  return newTable;
}

/* Task 1.2 */
void insertData(HashTable *table, void *key, void *data) {
  // -- TODO --
  // HINT:
  // 1. Find the right hash bucket location with table->hashFunction.
  // 2. Allocate a new hash bucket entry struct.
  // 3. Append to the linked list or create it if it does not yet exist.
  int index = table->hashFunction(key) % table->size;
  struct HashBucketEntry *newBucket = malloc(sizeof(struct HashBucketEntry));
  newBucket->key = key;
  newBucket->data = data;
  struct HashBucketEntry *entry = table->buckets[index];
  struct HashBucketEntry *last = entry;

  if (entry == NULL) {
    table->buckets[index] = newBucket;
    return;
  }

  do {
    if (table->equalFunction(entry->key, key)) {
      entry->data = data;
      free(newBucket);
      return;
    }
    last = entry;
    entry = entry->next;
  } while (entry != NULL);

  last->next = newBucket;
  return;
}

/* Task 1.3 */
void *findData(HashTable *table, void *key) {
  // -- TODO --
  // HINT:
  // 1. Find the right hash bucket with table->hashFunction.
  // 2. Walk the linked list and check for equality with table->equalFunction.
  int index = table->hashFunction(key) % table->size;
  struct HashBucketEntry *entry = table->buckets[index];
  while (entry != NULL) {
    if (table->equalFunction(key, entry->key)) {
      return entry->data;
    }
    entry = entry->next;
  }
  return NULL;
}

/* Task 2.1 */
unsigned int stringHash(void *s) {
  // -- TODO --
  /* To suppress compiler warning until you implement this function, */
  unsigned hashval;
  char *str = s;
  for (hashval = 0; *str != '\0'; str++) {
    hashval = *str + 31 * hashval;
  }

  return hashval;
}

/* Task 2.2 */
int stringEquals(void *s1, void *s2) {
  // -- TODO --
  /* To suppress compiler warning until you implement this function */
  if (strcmp(s1, s2)) {
    return 0;
  }

  return 1;
}