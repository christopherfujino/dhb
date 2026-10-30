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
    int64_t i = v.i;
    if (i >= 32 && i <= 126) {
      printf("%ld\t0x%.16lX\t0b%.64lb\t'%c'\n", i, i, i, (char)i);
    } else {
      printf("%ld\t0x%.16lX\t0b%.64lb\n", i, i, i);
    }
    break;
  case valueFloat: {
    int64_t view = v.i; // unsafe

    uint64_t sign = view & (1UL << 63);
    constexpr uint64_t elevenLsbs = 0x7FF;
    uint64_t exponent = (view >> 52) & elevenLsbs;
    constexpr uint64_t mantissaMask = 0x000FFFFFFFFFFFFFUL;
    uint64_t mantissa = view & mantissaMask;

    printf("%.1lb %.11lb %.52lb\n", sign, exponent, mantissa);

    printf("\u2502 \u251C");
    for (unsigned int i = 0; i < 9; i++) {
      printf("\u2500", stdout);
    }
    printf("\u2518");

    printf(" \u251C");
    for (unsigned int i = 0; i < 50; i++) {
      printf("\u2500");
    }
    printf("\u2518\n");

    printf("\u2502 \u2502");
    for (unsigned int i = 0; i < 11; i++) {
      fputc(' ', stdout);
    }
    printf("\u2514\tMantissa = %ld\n", mantissa);

    printf("\u2502 \u2514");
    for (unsigned int i = 0; i < 12; i++) {
      printf("\u2500");
    }
    printf(" Exponent = %ld", exponent);
    if (exponent == 0x7FF) {
      printf(" (NaN or infinity)\n");
    } else {
      fputc('\n', stdout);
    }

    printf("\u2514");
    for (unsigned int i = 0; i < 14; i++) {
      printf("\u2500");
    }

    if (sign) {
      printf(" Sign     = 1\n");
    } else {
      printf(" Sign     = 0\n");
    }

    double mantissaDecimal = 1.0;
    {
      for (int i = 0; i < 52; i++) {
        int bit = ((mantissa >> (51 - i)) & 0x1);
        double denominator = (pow(2.0, (i + 1)));
        double d = ((double)bit) / denominator;
        mantissaDecimal += d;
      }
    }
    printf("\n-1^%ld * 2^(%ld - 1023) * %g\n", sign, exponent, mantissaDecimal);
    // TODO check for special exponents:
    // - 0x000 means signed zero and subnormal numbers
    // - 0x7FF means infinite if F = 0 else NaN
    double a = pow(-1.0, (double)sign);
    double b = (double)pow(2.0, ((double)exponent - 1023.0));
    double product = a * b * mantissaDecimal;
    uint64_t *productView = (uint64_t *)&product;
    if (product != v.f) {
      double error = fabs(product - v.f);
      constexpr double tolerance = 1.0 / 1'000'000'000;
      if (error > tolerance) {
        fprintf(stderr, "Significant rounding error\n");
        abort();
      } else {
        fprintf(stderr, "Insignificant rounding error\n");
      }
    }
    printf("%g * %g * %g = %.17g (0x%lX)\n", a, b, mantissaDecimal, product,
           *productView);

    printf("%.17g\t0x%lX\n", v.f, v.i);
  }
  }
}

[[noreturn]] void usage(int code) {
  fprintf(stderr, "Usage: dhb [-f] [-h]\n");
  exit(code);
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
      usage(0);
    default:
      usage(1);
    }
  }
  yyparse();
}
