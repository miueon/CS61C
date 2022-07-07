#include "ll_cycle.h"
#include <stddef.h>

int ll_has_cycle(node *head) {
  node *fast = head;
  node *slow = head;
  while (fast != NULL) {
    if (fast->next != NULL) {
      fast = fast->next->next;
      slow = slow->next;
    } else {
      return 0;
    }
    if (slow == fast)
    {
    return 1;
    }
  }
  return 0;
}
