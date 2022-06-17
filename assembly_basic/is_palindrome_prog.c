#include <stdio.h>
#include <stdint.h>

extern uint32_t is_palindrome(const char *s);

int main() {
  const char *inputs[] = {
    "abba",
    "racecar",
    "swap paws",
    "not a palindrome",
    "another non palindrome",
    "almost but tsomla",
    NULL,
  };
  uint32_t i;
  for(i = 0; inputs[i]; i++) {
    printf("%s --> %c\n", inputs[i], is_palindrome(inputs[i]) ? 'Y' : 'N');
  }
  return 0;
}

#include <string.h>
#include <stdio.h>
#include <stdint.h>

/* A palindrome is a phrase that is the same forward as backwards */

uint32_t is_palindrome(const char *string) {
  uint32_t i;
  uint32_t len = strlen(string);

  for (i = 0; i < len / 2; i++) {
    if (string[i] != string[len - i - 1]) {
      return 0;
    }
  }
  return 1;
}
