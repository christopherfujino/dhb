# Dec Hex Bin

A REPL for integer or floating-point arithmetic, supporting decimal,
hexadecimal, and binary.

```
> 2
2       0x2     0b10
> 0x24 + 1
37      0x25    0b100101        '%'
> (1 << 8) - 1
255     0xFF    0b11111111
```

When invoked as `dhb -f`:

```
> 0.1 + 0.2
0 01111111101 0011001100110011001100110011001100110011001100110100
│ ├─────────┘ ├──────────────────────────────────────────────────┘
│ │           └ Mantissa = 900719925474100
│ └──────────── Exponent = 1021
└────────────── Sign     = 0

-1^0 * 2^(1021 - 1023) * 1.2
1 * 0.25 * 1.2 = 0.30000000000000004
```

## Values

By default, `dhb` uses 64-bit signed integers for all values. If you invoke
it as `dhb -f` it will run in floating-point mode, which uses
[binary64](https://en.wikipedia.org/wiki/Double-precision_floating-point_format)
double-precision floats.

## Operators

|Operator|Operation|Float support?|
|--|--|--|
|`+`|signed addition|Yes|
|`-`|signed subtraction|Yes|
|`*`|multiplication|Yes|
|`/`|division|Yes|
|`<<`|left shift|No|
|`>>`|right shift|No|
|`^`|exponentiate|Yes|
|`(` ... `)`|grouping (enforce precedence)|Yes|

## Building

Requires readline, flex, and bison.
