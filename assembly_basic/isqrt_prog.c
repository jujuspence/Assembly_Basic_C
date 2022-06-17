#include <stdio.h>
#include <stdint.h>

extern uint32_t isqrt(uint32_t n);

int main() {
  uint32_t inputs[] = { 1, 12, 225, 169, 16, 25, 100, 81, 99, 121, 144, 0 };
  uint32_t i;
  for(i = 0; inputs[i]; i++) {
    printf("%d\n", isqrt(inputs[i]));
  }
}
#include <stdint.h>
#include <stdint.h>

/* The integer square root of n is the largest integer whose square
   does not exceeed n.
   From wikipedia: https://en.wikipedia.org/wiki/Integer_square_root
*/

uint32_t isqrt(uint32_t n) {
  if(n<2) return n;
  uint32_t small = isqrt(n >> 2) << 1;
  uint32_t large = small + 1;
  if (large * large > n) 
    return small;
  else
    return large;
}
