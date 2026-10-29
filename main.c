#include <stdint.h>
#include <stdio.h>
#include <unistd.h>

#include "main.h"
#include "parser.tab.h"
#include "value.h"

// globals
Value prev = {};
Mode mode = modeInt;

void print(Value v) {
  switch (v.tag) {
  case valueInt:
    uint64_t i = v.i;
    if (i >= 32 && i <= 126) {
      printf("%ld\t0x%.16lX\t0b%.64lb\t'%c'\n", i, i, i, (char)i);
    } else {
      printf("%ld\t0x%.16lX\t0b%.64lb\n", i, i, i);
    }
    break;
  case valueFloat:
    double d = v.f;
    uint64_t *view = (uint64_t *)&d;
    // TODO validate this
    printf("%f\t0x%.4lX\t0b%lb\n", d, *view, *view);
  }
}

int main(int argc, char *argv[]) {
  int opt = -1;
  prev = valueOfInt(0);
  while ((opt = getopt(argc, argv, "fh")) != -1) {
    switch (opt) {
      case 'f':
        mode = modeFloat;
        prev = valueOfFloat(0);
        break;
      case 'h':
        fprintf(stderr, "Usage: dhb [-f] [-h]\n");
        return 0;
      default:
        fprintf(stderr, "Unknown CLI flag `-%c`!\n", opt);
    }
  }
  yyparse();
}
