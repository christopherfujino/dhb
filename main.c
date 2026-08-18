#include <stdio.h>

#include "parser.tab.h"

void print(long int i) {
  if (i >= 32 && i <= 126) {
    printf("%ld\t0x%lX\t0b%lb\t'%c'\n", i, i, i, (char)i);
  } else {
    printf("%ld\t0x%lX\t0b%lb\n", i, i, i);
  }
}

long int prev = 0;

int main(void) {
  yyparse();
}
