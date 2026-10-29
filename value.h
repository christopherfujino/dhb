#ifndef __MONOREPO_CPP_DHB_VALUE_H
#define __MONOREPO_CPP_DHB_VALUE_H

#include <stdint.h> // int64_t
#include <stdlib.h> // abort()
#include <tgmath.h> // pow()

static_assert(sizeof(long int) == 8, "longs must be 64-bit");
static_assert(sizeof(double) == 8, "longs must be 64-bit");

typedef struct {
  enum {
    valueInt,
    valueFloat,
  } tag;
  union {
    int64_t i;
    double f;
  };
} Value;

static inline Value valueOfInt(int64_t i) {
  return (Value){
      .tag = valueInt,
      .i = i,
  };
}

static inline Value valueOfFloat(double d) {
  return (Value){
      .tag = valueFloat,
      .f = d,
  };
}

static inline Value valueAdd(Value a, Value b) {
  if (a.tag != b.tag) {
    abort();
  }
  switch (a.tag) {
  case valueInt:
    return valueOfInt(a.i + b.i);
  case valueFloat:
    return valueOfFloat(a.f + b.f);
  }
}

static inline Value valueSubtract(Value a, Value b) {
  if (a.tag != b.tag) {
    abort();
  }
  switch (a.tag) {
  case valueInt:
    return valueOfInt(a.i - b.i);
  case valueFloat:
    return valueOfFloat(a.f - b.f);
  }
}

static inline Value valueMultiply(Value a, Value b) {
  if (a.tag != b.tag) {
    abort();
  }
  switch (a.tag) {
  case valueInt:
    return valueOfInt(a.i * b.i);
  case valueFloat:
    return valueOfFloat(a.f * b.f);
  }
}

static inline Value valueDivide(Value a, Value b) {
  if (a.tag != b.tag) {
    abort();
  }
  switch (a.tag) {
  case valueInt:
    if (b.i == 0) {
      abort();
    }
    return valueOfInt(a.i / b.i);
  case valueFloat:
    if (b.f == 0) {
      abort();
    }
    return valueOfFloat(a.f / b.f);
  }
}

static inline Value valueLeftShift(Value a, Value b) {
  if (!(a.tag == b.tag == valueInt)) {
    // floats don't support bit shifting
    abort();
  }
  return valueOfInt(a.i << b.i);
}

static inline Value valueRightShift(Value a, Value b) {
  if (!(a.tag == b.tag == valueInt)) {
    // floats don't support bit shifting
    abort();
  }
  return valueOfInt(a.i >> b.i);
}

static inline Value valuePower(Value a, Value b) {
  if (a.tag != b.tag) {
    abort();
  }
  switch(a.tag) {
    case valueInt:
      return valueOfInt(pow(a.i, b.i));
    case valueFloat:
      return valueOfFloat(pow(a.f, b.f));
  }
}

#endif // __MONOREPO_CPP_DHB_VALUE_H
