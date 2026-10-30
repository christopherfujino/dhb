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

## Values

By default, `dhb` uses 64-bit signed integers for all values. If you invoke
it as `dhb -f` it will run in floating-point mode, which uses
[binary64](https://en.wikipedia.org/wiki/Double-precision_floating-point_format)
double-precision floats.

## Operators

All values are represented internally as 64-bit signed integers.

|Operator|Operation|
|--|--|
|`+`|signed addition|
|`-`|signed subtraction|
|`*`|multiplication|
|`/`|division|
|`<<`|left shift|
|`>>`|right shift|
|`^`|exponentiate|
|`(` ... `)`|grouping (enforce precedence)|

## Building

Requires readline, flex, and bison.
