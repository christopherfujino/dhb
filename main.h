#ifndef __MONOREPO_CPP_DHB_MAIN_H
#define __MONOREPO_CPP_DHB_MAIN_H

#include "value.h"

typedef enum {
  modeInt,
  modeFloat,
} Mode;

void print(Value i);
int yylex(void);
extern Value prev;
extern Mode mode;

#endif // __MONOREPO_CPP_DHB_MAIN_H
