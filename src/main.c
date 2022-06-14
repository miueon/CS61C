#include "hashtable.h"
#include <stdio.h>

int main(int argc, char const *argv[]) {
  HashTable *dictionary = createHashTable(0x61c, &stringHash, &stringEquals);

  char *tkey = "in";
  char *tval = "out";
  insertData(dictionary, (void *)tkey, (void *)tval);
  fprintf(stdout, "data %s", (char *)findData(dictionary, (void *)tkey));
  return 0;
}
